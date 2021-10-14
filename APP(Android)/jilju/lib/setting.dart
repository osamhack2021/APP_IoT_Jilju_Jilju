import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'message.dart';
import 'util.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late int _numberPickerValue;

  Future<int?> _showWeightInputDialog(int currentWeight) async {
    _numberPickerValue = currentWeight;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('몸무게 수정'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return NumberPicker(
                minValue: 50,
                maxValue: 150,
                value: _numberPickerValue,
                onChanged: (value) {
                  setState(() {
                    _numberPickerValue = value;
                  });
                },
                haptics: true,
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context, _numberPickerValue);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserWeight(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int userWeight = snapshot.data as int;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Center(
                  child: Text(
                    '설정',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    const Icon(Icons.circle, size: 10),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('몸무게: $userWeight kg',
                          style: const TextStyle(fontSize: 20)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, size: 20),
                      onPressed: () async {
                        int? weight = await _showWeightInputDialog(userWeight);
                        if (weight == null) {
                          return;
                        }
                        setState(() {
                          setUserWeight(weight);
                        });
                      },
                      splashRadius: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(MessageManager.messageString[10],
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
