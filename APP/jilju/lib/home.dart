import 'package:flutter/material.dart';
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
  int touchedIndex = -1;

  void updateBottomTexts(int idx) {
    setState(() {
      touchedIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseManager.getJiljuLists(
          today().subtract(const Duration(days: 6)), 7),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<List<Jilju>> jiljuLists = snapshot.data as List<List<Jilju>>;
          List<Jilju> totalJiljuList =
              jiljuLists.reduce((a, b) => [...a, ...b]);
          return Column(
            children: <Widget>[
              SizedBox(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: Text(
                        '${Jilju.getSumOfDistance(totalJiljuList).toStringAsFixed(1)} km',
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                    Center(
                      child: Text(
                        durationToString(
                            Jilju.getSumOfTotalTime(totalJiljuList)),
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 480,
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(child: Chart(jiljuLists)),
                  ),
                ),
              ),
              SizedBox(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: Text(
                        touchedIndex == -1
                            ? ''
                            : '${Jilju.getSumOfDistance(jiljuLists[touchedIndex]).toStringAsFixed(1)} km',
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                    Center(
                      child: Text(
                        touchedIndex == -1
                            ? ''
                            : durationToString(Jilju.getSumOfTotalTime(
                                jiljuLists[touchedIndex])),
                        style: const TextStyle(fontSize: 32),
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
