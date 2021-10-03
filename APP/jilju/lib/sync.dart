import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'database.dart';
import 'main.dart';
import 'message.dart';
import 'model/jilju.dart';

class SyncPage extends StatefulWidget {
  SyncPage({Key? key}) : super(key: key);

  final FlutterBlue _flutterBlue = FlutterBlue.instance;

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  final List<dynamic> _devices = [];
  final Guid _ftpServiceGuid = Guid('0000181900001000800000805f9b34fb');
  final Guid _fileIdCharGuid = Guid('00002ac300001000800000805f9b34fb');
  final Guid _fileDataCharGuid = Guid('00002a6700001000800000805f9b34fb');
  final TextEditingController _passwordController = TextEditingController();
  bool _connectBtnPressed = false;

  void _addDeviceToSet(dynamic device) {
    if (device is! BluetoothDevice && device is! _VirtualDevice) {
      throw Exception();
    }
    setState(() {
      if (!_devices.contains(device)) {
        _devices.add(device);
      }
    });
  }

  BluetoothService? _findService(List<BluetoothService> services, Guid guid) {
    for (BluetoothService service in services) {
      if (service.uuid == guid) {
        return service;
      }
    }
    return null;
  }

  BluetoothCharacteristic? _findCharacteristic(
      BluetoothService service, Guid guid) {
    for (BluetoothCharacteristic characteristic in service.characteristics) {
      if (characteristic.uuid == guid) {
        return characteristic;
      }
    }
    return null;
  }

  Future<void> _writeIntegerToCharacteristic(
      BluetoothCharacteristic characteristic, int value) async {
    Uint8List bytes = Uint8List(4);
    bytes.buffer.asByteData().setInt32(0, value, Endian.little);
    return characteristic.write(bytes.toList());
  }

  Future<String> _readFileData(int fileId, BluetoothCharacteristic fileIdChar,
      BluetoothCharacteristic fileDataChar) async {
    String? fileData;
    StringBuffer buffer = StringBuffer();
    StreamSubscription subscription = fileDataChar.value.listen((value) {
      if (value.isNotEmpty &&
          (buffer.isNotEmpty || value[0] == '^'.codeUnitAt(0))) {
        buffer.write(String.fromCharCodes(value));
        if (value[value.length - 1] == '\$'.codeUnitAt(0)) {
          String bufStr = buffer.toString();
          fileData = bufStr.substring(1, bufStr.length - 1);
        }
      }
    });
    await fileDataChar.setNotifyValue(true);
    await _writeIntegerToCharacteristic(fileIdChar, fileId);
    await Future.doWhile(() => Future.delayed(const Duration(milliseconds: 100))
        .then((_) => fileData == null));
    await fileDataChar.setNotifyValue(false);
    await subscription.cancel();
    return fileData!;
  }

  Future<void> _connectToDevice(dynamic device) async {
    if (device is BluetoothDevice) {
      await _connectToBluetoothDevice(device);
    } else if (device is _VirtualDevice) {
      await _connectToVirtualDevice(device);
    } else {
      throw Exception();
    }
  }

  Future<void> _connectToBluetoothDevice(BluetoothDevice device) async {
    try {
      await device.connect();
    } on PlatformException catch (e) {
      if (e.code != 'already_connected') {
        MessageManager.showMessageDialog(context, 1);
        return;
      }
    }
    List<BluetoothService> services = await device.discoverServices();
    BluetoothService? ftpService = _findService(services, _ftpServiceGuid);
    if (ftpService == null) {
      MessageManager.showMessageDialog(context, 2);
      return;
    }
    BluetoothCharacteristic? fileIdChar =
        _findCharacteristic(ftpService, _fileIdCharGuid);
    BluetoothCharacteristic? fileDataChar =
        _findCharacteristic(ftpService, _fileDataCharGuid);
    if (fileIdChar == null || fileDataChar == null) {
      MessageManager.showMessageDialog(context, 3);
      return;
    }
    int? password = await _takePassword();
    if (password == null) {
      return;
    }
    _setProgressVisible(true);
    await _writeIntegerToCharacteristic(fileIdChar, password);
    for (int fileId = await DatabaseManager.getNextJiljuId();; fileId++) {
      String fileData = await _readFileData(fileId, fileIdChar, fileDataChar);
      if (fileData == '') {
        break;
      }
      DatabaseManager.putJilju(fileId, Jilju.fromFileData(fileData));
    }
    await device.disconnect();
    _setProgressVisible(false);
    MessageManager.showMessageDialog(context, 0);
  }

  Future<void> _connectToVirtualDevice(_VirtualDevice device) async {
    int? password = await _takePassword();
    if (password == null) {
      return;
    }
    _setProgressVisible(true);
    DatabaseManager.loadSampleDatas();
    Future.delayed(const Duration(seconds: 10), () {
      _setProgressVisible(false);
      MessageManager.showMessageDialog(context, 0);
    });
  }

  Future<int?> _takePassword() async {
    String? passwordStr = await _showPasswordInputDialog();
    if (passwordStr == null) {
      return null;
    } else if (passwordStr.length != 8) {
      MessageManager.showMessageDialog(context, 4);
      return null;
    }
    return int.parse(passwordStr);
  }

  Future<String?> _showPasswordInputDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('비밀번호 입력'),
          content: TextField(
            controller: _passwordController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(8),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                String passwordStr = _passwordController.text;
                _passwordController.clear();
                Navigator.pop(context, passwordStr);
              },
            ),
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                _passwordController.clear();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _setProgressVisible(bool visible) {
    context
        .findAncestorStateOfType<JiljuMainPageState>()!
        .setProgressVisible(visible);
  }

  @override
  void initState() {
    super.initState();
    widget._flutterBlue.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.name == 'Jilju') {
          _addDeviceToSet(result.device);
        }
      }
    });
    widget._flutterBlue.startScan();
    if (JiljuApp.testMode) {
      _addDeviceToSet(_VirtualDevice('Virtual Device for Test'));
    }
  }

  ListView _buildListViewOfDevices() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return SizedBox(
          height: 80,
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.devices, size: 32),
                  Expanded(
                    child: Center(
                      child: Text(_devices[index].id.toString(),
                          style: const TextStyle(fontSize: 32)),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () async {
              if (!_connectBtnPressed) {
                _connectBtnPressed = true;
                await _connectToDevice(_devices[index]);
                _connectBtnPressed = false;
              }
            },
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: _devices.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_devices.isEmpty) {
      return Center(
        child: Text(
          MessageManager.messageString[5],
          style: const TextStyle(fontSize: 32),
        ),
      );
    } else {
      return _buildListViewOfDevices();
    }
  }
}

class _VirtualDevice {
  _VirtualDevice(this.id);

  final String id;
}
