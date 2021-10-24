import 'package:flutter/material.dart';
import 'package:jilju/theme.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database.dart';
import 'main.dart';
import 'message.dart';
import 'util.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late int _userWeight, _numberPickerValue;
  late JiljuTheme _jiljuTheme, _themeSelectionValue;

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

  Future<JiljuTheme?> _showThemeSelectionDialog() async {
    _themeSelectionValue = _jiljuTheme;
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
                    children: JiljuTheme.values
                        .map((jiljuTheme) => SizedBox(
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
                            ))
                        .toList(),
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

  void _setProgressVisible(bool visible) {
    context
        .findAncestorStateOfType<JiljuMainPageState>()!
        .setProgressVisible(visible);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllSettings(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> settings = snapshot.data as Map<String, dynamic>;
          _userWeight = settings['userWeight'];
          _jiljuTheme = settings['theme'];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              const Center(
                child: Text('설정', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 10),
              Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        const Expanded(
                            child: Text('몸무게', style: TextStyle(fontSize: 20))),
                        Text('$_userWeight kg',
                            style: const TextStyle(fontSize: 20)),
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
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        const Expanded(
                            child: Text('테마', style: TextStyle(fontSize: 20))),
                        Text(_jiljuTheme.name,
                            style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  onTap: () async {
                    JiljuTheme? jiljuTheme = await _showThemeSelectionDialog();
                    if (jiljuTheme == null) {
                      return;
                    }
                    setState(() {
                      setTheme(jiljuTheme);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text(MessageManager.messageString[11],
                    style: const TextStyle(fontSize: 12)),
              ),
              const SizedBox(height: 10),
              Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
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
                    var json = await DatabaseManager.toJson();
                    debugPrint(json.toString());
                  },
                ),
              ),
              Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
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
                    var json = await DatabaseManager.toJson();
                    await DatabaseManager.fromJson(json);
                    debugPrint('success...');
                  },
                ),
              ),
              Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
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
                    _setProgressVisible(true);
                    await DatabaseManager.clearAllData();
                    _setProgressVisible(false);
                    await MessageManager.showMessageDialog(context, 13);
                  },
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
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

Future<Map<String, dynamic>> getAllSettings() async {
  Map<String, dynamic> settings = {};
  settings['userWeight'] = await getUserWeight();
  settings['theme'] = await getTheme();
  return settings;
}
