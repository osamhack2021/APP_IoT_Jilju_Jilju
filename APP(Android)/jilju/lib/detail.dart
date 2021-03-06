import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jilju/util.dart';

import 'chart.dart';
import 'database.dart';
import 'message.dart';
import 'model/jilju.dart';
import 'model/jilju_tag.dart';
import 'setting.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  _DetailPageState()
      : _startDate = today(),
        _endDate = today(),
        _jiljuMap = {today(): []},
        _totalJiljuList = [],
        _jiljuTags = [] {
    _updateJiljuData();
  }

  DateTime _startDate;
  DateTime _endDate;
  Map<DateTime, List<Jilju>> _jiljuMap;
  List<Jilju> _totalJiljuList;
  final List<JiljuTag> _jiljuTags;
  final TextEditingController _tagNameController = TextEditingController();

  Future<void> _updateJiljuData() async {
    _jiljuMap = await DatabaseManager.getJiljuMap(
        _startDate, _endDate.difference(_startDate).inDays + 1);
    _jiljuMap.updateAll((dateTime, jiljuList) {
      for (JiljuTag jiljuTag in _jiljuTags) {
        jiljuList = jiljuList
            .where((jilju) => jiljuTag.jiljuIds.contains(jilju.id))
            .toList();
      }
      return jiljuList;
    });
    _totalJiljuList = _jiljuMap.values.reduce((a, b) => [...a, ...b]);
    setState(() {});
  }

  Future<void> _showJiljuDetailDialog(Jilju jilju) async {
    List<JiljuTag> jiljuTags = await jilju.jiljuTags();
    int userWeight = await getUserWeight();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${jilju.id}번째 질주'),
          content: Wrap(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CustomPaint(
                    painter: _JiljuPainter(jilju),
                    size: const Size(192, 192),
                  ),
                  const SizedBox(height: 10),
                  StatefulBuilder(
                    builder: (context, setState) =>
                        _buildJiljuTagSelector(jilju, jiljuTags, setState),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      const Expanded(
                        flex: 2,
                        child: Text(
                          '일시',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          '${dateToString(secondsToDateTime(jilju.startTime))}\n'
                          '${timeToString(secondsToDateTime(jilju.startTime))}'
                          ' ~ ${timeToString(secondsToDateTime(jilju.endTime))}',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const <Widget>[
                      Expanded(
                        child: Text(
                          '질주 거리',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '질주 시간',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${jilju.distance.toStringAsFixed(1)} km',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          durationToString(jilju.totalTime),
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const <Widget>[
                      Expanded(
                        child: Text(
                          '평균 속력',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '소모 칼로리',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${jilju.averageSpeed.toStringAsFixed(1)} km/h',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${caloriesBurned(userWeight, jilju.averageSpeed, jilju.totalTime.inMinutes).toStringAsFixed(1)} kcal',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
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

  Future<JiljuTag?> _showJiljuTagDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('태그'),
              content: FutureBuilder(
                future: DatabaseManager.getAllJiljuTags(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<JiljuTag> allJiljuTags =
                        snapshot.data as List<JiljuTag>;
                    return AspectRatio(
                      aspectRatio: 0.6,
                      child: allJiljuTags.isEmpty
                          ? Center(
                              child: Text(
                              MessageManager.messageString[7],
                              style: const TextStyle(fontSize: 16),
                            ))
                          : _buildListViewOfJiljuTags(allJiljuTags, setState),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('NEW TAG'),
                  onPressed: () async {
                    String? tagName = await _showTagNameInputDialog();
                    if (tagName == null) {
                      return;
                    }
                    setState(() {
                      JiljuTag jiljuTag = JiljuTag(tagName);
                      DatabaseManager.putJiljuTag(jiljuTag);
                    });
                  },
                ),
                TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<String?> _showTagNameInputDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        _tagNameController.clear();
        return AlertDialog(
          title: const Text('새로운 태그'),
          content: TextField(
            controller: _tagNameController,
            keyboardType: TextInputType.text,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[\u0000-\u007F]')),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                String tagName = _tagNameController.text;
                if (tagName.isEmpty) {
                  await MessageManager.showMessageDialog(context, 8);
                } else if (await DatabaseManager.containsJiljuTag(tagName)) {
                  await MessageManager.showMessageDialog(context, 6);
                } else {
                  Navigator.pop(context, tagName);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateRangePicker() {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            const Icon(Icons.event_note, size: 20),
            Expanded(
              child: Text(
                '${dateToString(_startDate)} ~ ${dateToString(_endDate)}',
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      onTap: () async {
        DateTimeRange? dateTimeRange = await showDateRangePicker(
          context: context,
          initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
          firstDate: DateTime(2020, 1, 1),
          lastDate: DateTime(2029, 12, 31),
        );
        if (dateTimeRange == null) {
          return;
        }
        _startDate = dateTimeRange.start;
        _endDate = dateTimeRange.end;
        _updateJiljuData();
      },
    );
  }

  Widget _buildJiljuTagSelector(Jilju? jilju, List<JiljuTag> jiljuTags,
      void Function(void Function()) setState) {
    return Row(
      children: <Widget>[
        const Icon(Icons.tag, size: 20),
        const SizedBox(width: 5),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                ...jiljuTags
                    .map((jiljuTag) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: OutlinedButton(
                            child: Text(
                              jiljuTag.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              setState(() {
                                jiljuTags.remove(jiljuTag);
                              });
                              if (jilju != null) {
                                jiljuTag.removeJilju(jilju);
                              }
                            },
                          ),
                        ))
                    .toList(),
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () async {
                    JiljuTag? jiljuTag = await _showJiljuTagDialog();
                    if (jiljuTag == null) {
                      return;
                    }
                    setState(() {
                      jiljuTags.remove(jiljuTag);
                      jiljuTags.add(jiljuTag);
                    });
                    if (jilju != null) {
                      jiljuTag.addJilju(jilju);
                    }
                  },
                  splashRadius: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ListView _buildListViewOfJiljuTags(
      List<JiljuTag> jiljuTags, void Function(void Function()) setState) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return InkWell(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Row(
              children: <Widget>[
                const Icon(Icons.tag, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    jiljuTags[index].name,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () async {
                    bool? delete =
                        await MessageManager.showYesNoDialog(context, 9);
                    if (delete == null || !delete) {
                      return;
                    }
                    setState(() {
                      DatabaseManager.deleteJiljuTag(jiljuTags[index]);
                    });
                  },
                  splashRadius: 20,
                ),
              ],
            ),
          ),
          onTap: () => Navigator.pop(context, jiljuTags[index]),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        thickness: 1,
      ),
      itemCount: jiljuTags.length,
    );
  }

  ListView _buildListViewOfJiljus() {
    return ListView.separated(
      itemBuilder: (context, index) {
        Jilju jilju = _totalJiljuList[index];
        return Dismissible(
          key: Key(jilju.id.toString()),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.delete_outline, size: 20),
            ),
          ),
          confirmDismiss: (direction) =>
              MessageManager.showYesNoDialog(context, 18),
          onDismissed: (direction) {
            DatabaseManager.deleteJilju(jilju);
            DateTime dateTime = secondsToDateTime(jilju.startTime);
            dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
            setState(() {
              _jiljuMap[dateTime]!.remove(jilju);
              _totalJiljuList.remove(jilju);
            });
          },
          direction: DismissDirection.endToStart,
          child: InkWell(
            child: SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.directions_run, size: 20),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          '${dateToString(secondsToDateTime(jilju.startTime))}\n'
                          '${timeToString(secondsToDateTime(jilju.startTime))}'
                          ' ~ ${timeToString(secondsToDateTime(jilju.endTime))}',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          '${jilju.distance.toStringAsFixed(1)} km\n'
                          '${durationToString(jilju.totalTime)}',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () => _showJiljuDetailDialog(jilju),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        thickness: 1,
      ),
      itemCount: _totalJiljuList.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildDateRangePicker(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildJiljuTagSelector(null, _jiljuTags, setState),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.2,
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
                      child: _jiljuMap.length <= 7
                          ? JiljuBarChart(_jiljuMap, null)
                          : JiljuLineChart(_jiljuMap),
                    ),
                  ),
                ),
                _buildListViewOfJiljus(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _JiljuPainter extends CustomPainter {
  final Jilju _jilju;

  _JiljuPainter(Jilju jilju) : _jilju = jilju.simplifyPoints();

  @override
  void paint(Canvas canvas, Size size) {
    int maxX = _jilju.points.map((jiljuPoint) => jiljuPoint.x).reduce(max);
    int maxY = _jilju.points.map((jiljuPoint) => jiljuPoint.y).reduce(max);
    int minX = _jilju.points.map((jiljuPoint) => jiljuPoint.x).reduce(min);
    int minY = _jilju.points.map((jiljuPoint) => jiljuPoint.y).reduce(min);
    int maxLength = max(maxX - minX, maxY - minY) + 1;
    int plusX =
        ((size.width - 1) - ((maxX - minX) * size.width ~/ maxLength)) ~/ 2;
    int plusY =
        ((size.height - 1) - ((maxY - minY) * size.height ~/ maxLength)) ~/ 2;
    List<Offset> offsets = _jilju.points
        .map((jiljuPoint) => Offset(
            ((jiljuPoint.x - minX) * size.width ~/ maxLength + plusX)
                .toDouble(),
            (size.height - 1) -
                ((jiljuPoint.y - minY) * size.height ~/ maxLength + plusY)))
        .toList();
    Paint paint = Paint()
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    const Color startColor = Colors.greenAccent;
    const Color endColor = Colors.redAccent;
    for (int i = 1; i < offsets.length; i++) {
      paint.shader = ui.Gradient.linear(offsets[i - 1], offsets[i], [
        Color.lerp(
            startColor,
            endColor,
            _jilju.points[i - 1].time /
                _jilju.points[_jilju.points.length - 1].time)!,
        Color.lerp(
            startColor,
            endColor,
            _jilju.points[i].time /
                _jilju.points[_jilju.points.length - 1].time)!
      ]);
      canvas.drawLine(offsets[i - 1], offsets[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
