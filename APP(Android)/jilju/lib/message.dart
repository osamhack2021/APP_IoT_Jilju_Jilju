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
    '소모 칼로리 계산에 사용됩니다.',
    '앱을 재시작해야 적용됩니다.',
    '모든 데이터를 지웁니다. 이 작업은 돌이킬 수 없습니다.',
    '모든 데이터를 지웠습니다.',
    '백업 코드를 반드시 기록해두십시오.'
        '\n백업 코드 분실 시 복원이 불가합니다.'
        '\n백업 코드는 72시간 후에 만료됩니다.',
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

  static Future<bool?> showYesNoDialog(
      BuildContext context, int messageId) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('알림'),
          content: Text(MessageManager.messageString[messageId]),
          actions: <Widget>[
            TextButton(
              child: const Text('YES'),
              onPressed: () => Navigator.pop(context, true),
            ),
            TextButton(
              child: const Text('NO'),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        );
      },
    );
  }
}
