import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'detail.dart';
import 'home.dart';
import 'model/jilju.dart';
import 'model/jilju_point.dart';
import 'model/jilju_tag.dart';
import 'setting.dart';
import 'sync.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(JiljuAdapter());
  Hive.registerAdapter(JiljuPointAdapter());
  Hive.registerAdapter(JiljuTagAdapter());
  await Firebase.initializeApp();
  runApp(const JiljuApp());
}

class JiljuApp extends StatelessWidget {
  const JiljuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeChangeNotifier(),
      child: Consumer(
        builder: (context, ThemeChangeNotifier notifier, child) {
          JiljuTheme jiljuTheme = notifier.theme;
          return MaterialApp(
            title: 'Jilju',
            theme: jiljuTheme.theme,
            home: AnimatedSplashScreen(
              splash: Image(
                  image: AssetImage('assets/splash_${jiljuTheme.name}.png')),
              nextScreen: const JiljuMainPage(),
              pageTransitionType: PageTransitionType.fade,
              splashIconSize: 250,
              backgroundColor: jiljuTheme.splashScreenBackgroundColor,
            ),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
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
    const SyncPage(),
    const SettingPage(),
  ];
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_index]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
          BottomNavigationBarItem(label: '', icon: Icon(Icons.settings)),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
