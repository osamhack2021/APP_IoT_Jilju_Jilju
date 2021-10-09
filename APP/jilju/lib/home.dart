import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'chart.dart';
import 'database.dart';
import 'model/jilju.dart';
import 'util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RecentDays _recentDays = RecentDays.recent7days;
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseManager.getJiljuMap(
          today().subtract(Duration(days: _recentDays.days() - 1)),
          _recentDays.days()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<DateTime, List<Jilju>> jiljuMap =
              snapshot.data as Map<DateTime, List<Jilju>>;
          List<Jilju> totalJiljuList =
              jiljuMap.values.reduce((a, b) => [...a, ...b]);
          return Column(
            children: <Widget>[
              const SizedBox(height: 20),
              ToggleSwitch(
                minWidth: 100,
                minHeight: 50,
                fontSize: 16,
                initialLabelIndex: _recentDays.index,
                totalSwitches: 2,
                labels: RecentDays.values
                    .map((recentDays) => '최근 ${recentDays.days()}일')
                    .toList(),
                onToggle: (index) {
                  setState(() {
                    _recentDays = RecentDays.values[index];
                    _touchedIndex = -1;
                  });
                },
              ),
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: Text(
                        '${Jilju.getSumOfDistance(totalJiljuList).toStringAsFixed(1)} km',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    Center(
                      child: Text(
                        durationToString(
                            Jilju.getSumOfTotalTime(totalJiljuList)),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ),
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
                        ? JiljuBarChart(jiljuMap, (event, response) {
                            if (!event.isInterestedForInteractions ||
                                response == null ||
                                response.spot == null) {
                              return;
                            }
                            setState(() {
                              _touchedIndex =
                                  response.spot!.touchedBarGroupIndex;
                            });
                          })
                        : JiljuLineChart(jiljuMap),
                  ),
                ),
              ),
              if (_touchedIndex != -1)
                SizedBox(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Center(
                        child: Text(
                          '${Jilju.getSumOfDistance(jiljuMap.values.toList()[_touchedIndex]).toStringAsFixed(1)} km',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      Center(
                        child: Text(
                          durationToString(Jilju.getSumOfTotalTime(
                              jiljuMap.values.toList()[_touchedIndex])),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
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

enum RecentDays { recent7days, recent30days }

extension RecentDaysExtension on RecentDays {
  int days() {
    switch (this) {
      case RecentDays.recent7days:
        return 7;
      case RecentDays.recent30days:
        return 30;
    }
  }
}
