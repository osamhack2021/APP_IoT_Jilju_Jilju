import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'chart.dart';
import 'database.dart';
import 'model/jilju.dart';
import 'util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  RecentDays _recentDays = RecentDays.recent7days;
  int _touchedIndex = -1;

  void updateBottomTexts(int index) {
    setState(() {
      _touchedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseManager.getJiljuLists(
          today().subtract(Duration(days: _recentDays.days() - 1)),
          _recentDays.days()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<List<Jilju>> jiljuLists = snapshot.data as List<List<Jilju>>;
          List<Jilju> totalJiljuList =
              jiljuLists.reduce((a, b) => [...a, ...b]);
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
              Expanded(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  child: Chart(jiljuLists),
                ),
              ),
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: Text(
                        _touchedIndex == -1
                            ? ''
                            : '${Jilju.getSumOfDistance(jiljuLists[_touchedIndex]).toStringAsFixed(1)} km',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    Center(
                      child: Text(
                        _touchedIndex == -1
                            ? ''
                            : durationToString(Jilju.getSumOfTotalTime(
                                jiljuLists[_touchedIndex])),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return const SizedBox.shrink();
        } else {
          return const Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
          );
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
