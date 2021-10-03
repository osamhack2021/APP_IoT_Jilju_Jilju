import 'package:flutter/material.dart';
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
                        '${Jilju.getSumOfTotalTime(totalJiljuList)}',
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
                  child: Center(child: Chart(jiljuLists)),
                ),
              ),
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
                        '${Jilju.getSumOfTotalTime(totalJiljuList)}',
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
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
