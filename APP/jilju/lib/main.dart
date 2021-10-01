import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jilju/sync.dart';

import 'detail.dart';
import 'home.dart';
import 'model/jilju.dart';
import 'model/jilju_point.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(JiljuAdapter());
  Hive.registerAdapter(JiljuPointAdapter());
  runApp(const JiljuApp());
}

class JiljuApp extends StatelessWidget {
  static bool testMode = true;
  const JiljuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jilju',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const JiljuMainPage(),
    );
  }
}

class JiljuMainPage extends StatefulWidget {
  const JiljuMainPage({Key? key}) : super(key: key);

  @override
  State<JiljuMainPage> createState() => JiljuMainPageState();
}

class JiljuMainPageState extends State<JiljuMainPage> {
  final _pages = [
    const HomePage(),
    const DetailPage(),
    SyncPage(),
  ];
  int _index = 0;
  bool _isProgressVisible = false;

  void setProgressVisible(bool visible) {
    setState(() {
      _isProgressVisible = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: _pages[_index],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              setState(() {
                _index = index;
              });
            },
            currentIndex: _index,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
              BottomNavigationBarItem(
                  label: 'Detail', icon: Icon(Icons.event_note)),
              BottomNavigationBarItem(label: 'Sync', icon: Icon(Icons.sync)),
            ],
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        ),
        Visibility(
          visible: _isProgressVisible,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: const Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
