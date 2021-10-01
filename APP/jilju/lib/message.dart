import 'package:flutter/material.dart';

class MessageManager {
  static final List<String> messageString = [
    '모든 데이터를 동기화하였습니다.',
    '기기에 연결할 수 없습니다.',
    'service not found',
    'characteristic not found',
    '비밀번호는 8자리 숫자입니다.',
    '검색된 기기가 없습니다!',
  ];

  static void showMessageDialog(BuildContext context, int messageId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('알림'),
          content: Text(messageString[messageId]),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
