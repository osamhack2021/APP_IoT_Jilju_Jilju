import 'package:flutter/material.dart';

class MessageManager {
  static final List<String> messageString = [
    '동기화가 완료되었습니다.',
    '기기에 연결할 수 없습니다.',
    'service not found',
    'characteristic not found',
    '8자리 숫자를 입력하십시오.',
    '검색된 기기가 없습니다!',
    '태그 이름이 중복되었습니다.',
    '등록된 태그가 없습니다!',
    '태그 이름을 입력하십시오.',
    '태그를 삭제하시겠습니까?',
    '몸무게는 소모 칼로리 계산에 사용됩니다.'
  ];

  static Future<void> showMessageDialog(
      BuildContext context, int messageId) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('알림'),
          content: Text(
            messageString[messageId],
            style: const TextStyle(fontSize: 16),
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
}
