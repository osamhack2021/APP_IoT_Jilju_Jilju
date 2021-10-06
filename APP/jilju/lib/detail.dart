import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jilju/util.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'chart.dart';
import 'database.dart';
import 'model/jilju.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  _DetailPageState()
      : _startDate = today(),
        _endDate = today();

  DateTime _startDate;
  DateTime _endDate;

  Future<PickerDateRange?> _showDatePickerDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: AspectRatio(
            aspectRatio: 0.6,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange: PickerDateRange(_startDate, _endDate),
                showActionButtons: true,
                onSubmit: (value) => Navigator.pop(context, value),
                onCancel: () => Navigator.pop(context),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showJiljuDetailDialog(Jilju jilju) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('질주 상세'),
          content: Wrap(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return CustomPaint(
                          painter: _JiljuPainter(jilju),
                          size:
                              Size(constraints.maxWidth, constraints.maxHeight),
                        );
                      },
                    ),
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
                          durationToString(jilju.totalTime()),
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
                        child: SizedBox.shrink(),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${jilju.averageSpeed().toStringAsFixed(1)} km/h',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Expanded(
                        child: SizedBox.shrink(),
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
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  ListView _buildListViewOfJiljus(List<Jilju> jiljuList) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return InkWell(
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
                        '${dateToString(secondsToDateTime(jiljuList[index].startTime))}\n'
                        '${timeToString(secondsToDateTime(jiljuList[index].startTime))}'
                        ' ~ ${timeToString(secondsToDateTime(jiljuList[index].endTime))}',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        '${jiljuList[index].distance.toStringAsFixed(1)} km\n'
                        '${durationToString(jiljuList[index].totalTime())}',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () => _showJiljuDetailDialog(jiljuList[index]),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        thickness: 1,
      ),
      itemCount: jiljuList.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          child: SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
          ),
          onTap: () async {
            PickerDateRange? pickerDateRange = await _showDatePickerDialog();
            if (pickerDateRange == null) {
              return;
            }
            setState(() {
              _startDate = pickerDateRange.startDate!;
              _endDate = pickerDateRange.endDate ?? _startDate;
            });
          },
        ),
        Expanded(
          child: FutureBuilder(
            future: DatabaseManager.getJiljuMap(
                _startDate, _endDate.difference(_startDate).inDays + 1),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<DateTime, List<Jilju>> jiljuMap =
                    snapshot.data as Map<DateTime, List<Jilju>>;
                List<Jilju> totalJiljuList =
                    jiljuMap.values.reduce((a, b) => [...a, ...b]);
                return SingleChildScrollView(
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
                            child: jiljuMap.length <= 7
                                ? JiljuBarChart(jiljuMap, null)
                                : JiljuLineChart(jiljuMap),
                          ),
                        ),
                      ),
                      _buildListViewOfJiljus(totalJiljuList),
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}

class _JiljuPainter extends CustomPainter {
  final Jilju _jilju;

  _JiljuPainter(this._jilju);

  @override
  void paint(Canvas canvas, Size size) {
    int maxX = _jilju.points.map((jiljuPoint) => jiljuPoint.x).reduce(max);
    int maxY = _jilju.points.map((jiljuPoint) => jiljuPoint.y).reduce(max);
    int minX = _jilju.points.map((jiljuPoint) => jiljuPoint.x).reduce(min);
    int minY = _jilju.points.map((jiljuPoint) => jiljuPoint.y).reduce(min);
    int maxLength = max(maxX - minX, maxY - minY) + 1;
    List<Offset> points = _jilju.points
        .map((jiljuPoint) => Offset(
            ((jiljuPoint.x - minX) * size.width ~/ maxLength).toDouble(),
            (size.height - 1) -
                ((jiljuPoint.y - minY) * size.height ~/ maxLength)))
        .toList();
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(PointMode.polygon, points, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
