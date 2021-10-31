import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'database.dart';
import 'message.dart';
import 'util.dart';

class SettingDataPage extends StatefulWidget {
  const SettingDataPage({Key? key}) : super(key: key);

  @override
  _SettingDataPageState createState() => _SettingDataPageState();
}

class _SettingDataPageState extends State<SettingDataPage> {
  final TextEditingController _backupCodeController = TextEditingController();

  Future<void> _showBackupCompleteDialog(String backupCode) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('백업 완료'),
          content: Wrap(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Expanded(
                        child: Text('백업 코드', style: TextStyle(fontSize: 16)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.content_copy, size: 14),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: backupCode));
                        },
                        splashRadius: 14,
                      ),
                    ],
                  ),
                  Center(
                    child: TextField(
                      controller: TextEditingController()..text = backupCode,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    MessageManager.messageString[14],
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showBackupCodeInputDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        _backupCodeController.clear();
        return AlertDialog(
          title: const Text('백업 코드 입력'),
          content: TextField(
            controller: _backupCodeController,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () =>
                  Navigator.pop(context, _backupCodeController.text),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('데이터 관리'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              child: InkWell(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    children: const <Widget>[
                      Expanded(
                        child: Text(
                          '데이터 백업하기',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  setProgressVisible(context, true);
                  DocumentReference df =
                      await FirebaseFirestore.instance.collection('jilju').add({
                    'data': await DatabaseManager.toJson(),
                    'timestamp': DateTime.now().millisecondsSinceEpoch,
                  });
                  setProgressVisible(context, false);
                  await _showBackupCompleteDialog(df.id);
                },
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              child: InkWell(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    children: const <Widget>[
                      Expanded(
                        child: Text(
                          '데이터 복원하기',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  String? backupCode = await _showBackupCodeInputDialog();
                  if (backupCode == null) {
                    return;
                  }
                  setProgressVisible(context, true);
                  DocumentSnapshot ds = await FirebaseFirestore.instance
                      .collection('jilju')
                      .doc(backupCode)
                      .get();
                  setProgressVisible(context, false);
                  if (ds.data() == null) {
                    await MessageManager.showMessageDialog(context, 15);
                    return;
                  }
                  Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
                  bool? restore =
                      await MessageManager.showYesNoDialog(context, 16);
                  if (restore == null || !restore) {
                    return;
                  }
                  setProgressVisible(context, true);
                  await DatabaseManager.clearAllData();
                  await DatabaseManager.fromJson(data['data']);
                  await MessageManager.showMessageDialog(context, 17);
                  setProgressVisible(context, false);
                },
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              child: InkWell(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    children: const <Widget>[
                      Expanded(
                        child: Text(
                          '모든 데이터 지우기',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  bool? clear =
                      await MessageManager.showYesNoDialog(context, 12);
                  if (clear == null || !clear) {
                    return;
                  }
                  setProgressVisible(context, true);
                  await DatabaseManager.clearAllData();
                  setProgressVisible(context, false);
                  await MessageManager.showMessageDialog(context, 13);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
