import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';

import 'detail.dart';
import 'home.dart';
import 'model/jilju.dart';
import 'model/jilju_point.dart';
import 'model/jilju_tag.dart';
import 'sync.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(JiljuAdapter());
  Hive.registerAdapter(JiljuPointAdapter());
  Hive.registerAdapter(JiljuTagAdapter());
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
      home: AnimatedSplashScreen(
        splash: const Image(image: AssetImage('assets/splash.png')),
        nextScreen: const JiljuMainPage(),
        pageTransitionType: PageTransitionType.fade,
        splashIconSize: 250,
      ),
      debugShowCheckedModeBanner: false,
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
              BottomNavigationBarItem(label: '', icon: Icon(Icons.home)),
              BottomNavigationBarItem(label: '', icon: Icon(Icons.event_note)),
              BottomNavigationBarItem(label: '', icon: Icon(Icons.sync)),
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
