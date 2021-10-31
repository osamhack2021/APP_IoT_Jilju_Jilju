import 'package:flutter/material.dart';
import 'package:jilju/theme.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'message.dart';
import 'setting_data.dart';
import 'util.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late int _userWeight, _numberPickerValue;
  late JiljuTheme _themeSelectionValue;

  Future<int?> _showWeightInputDialog() async {
    _numberPickerValue = _userWeight;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('몸무게 변경'),
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
              onPressed: () => Navigator.pop(context, _numberPickerValue),
            ),
          ],
        );
      },
    );
  }

  Future<JiljuTheme?> _showThemeSelectionDialog(JiljuTheme currentTheme) async {
    _themeSelectionValue = currentTheme;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('테마 선택'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Wrap(
                children: <Widget>[
                  Column(
                    children: JiljuTheme.values.map((jiljuTheme) {
                      return SizedBox(
                        height: 50,
                        child: InkWell(
                          child: Row(
                            children: <Widget>[
                              Radio<JiljuTheme>(
                                  value: jiljuTheme,
                                  groupValue: _themeSelectionValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _themeSelectionValue = value!;
                                    });
                                  }),
                              const SizedBox(width: 10),
                              Text(jiljuTheme.name,
                                  style: const TextStyle(fontSize: 20)),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              _themeSelectionValue = jiljuTheme;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
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
                Navigator.pop(context, _themeSelectionValue);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 20),
        const Center(
          child: Text('설정', style: TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 10),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: <Widget>[
                  const Expanded(
                    child: Text('몸무게', style: TextStyle(fontSize: 20)),
                  ),
                  FutureBuilder(
                    future: getUserWeight(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _userWeight = snapshot.data as int;
                        return Text(
                          '$_userWeight kg',
                          style: const TextStyle(fontSize: 20),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
            onTap: () async {
              int? weight = await _showWeightInputDialog();
              if (weight == null) {
                return;
              }
              setState(() {
                setUserWeight(weight);
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Text(MessageManager.messageString[10],
              style: const TextStyle(fontSize: 12)),
        ),
        const SizedBox(height: 10),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          child: Consumer(
            builder: (context, ThemeChangeNotifier notifier, child) {
              JiljuTheme jiljuTheme = notifier.theme;
              return InkWell(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      const Expanded(
                          child: Text('테마', style: TextStyle(fontSize: 20))),
                      Text(jiljuTheme.name,
                          style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                onTap: () async {
                  JiljuTheme? _jiljuTheme =
                      await _showThemeSelectionDialog(jiljuTheme);
                  if (_jiljuTheme == null) {
                    return;
                  }
                  notifier.theme = _jiljuTheme;
                },
              );
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: const <Widget>[
                  Expanded(
                    child: Text(
                      '데이터 관리',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingDataPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

Future<int> getUserWeight() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getInt('userWeight') ?? defaultUserWeight;
}

Future<bool> setUserWeight(int weight) async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.setInt('userWeight', weight);
}

Future<JiljuTheme> getTheme() async {
  var prefs = await SharedPreferences.getInstance();
  String themeName = prefs.getString('theme') ?? JiljuTheme.values[0].name;
  return JiljuTheme.values
      .where((jiljuTheme) => jiljuTheme.name == themeName)
      .first;
}

Future<bool> setTheme(JiljuTheme jiljuTheme) async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.setString('theme', jiljuTheme.name);
}
