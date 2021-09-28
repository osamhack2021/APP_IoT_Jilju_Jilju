import 'package:flutter/material.dart';
import 'package:jilju/sync.dart';

import 'detail.dart';
import 'home.dart';

void main() {
  runApp(const Jilju());
}

class Jilju extends StatelessWidget {
  const Jilju({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '질주',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const JiljuMainPage(title: '질주'),
    );
  }
}

class JiljuMainPage extends StatefulWidget {
  const JiljuMainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<JiljuMainPage> createState() => _JiljuMainPageState();
}

class _JiljuMainPageState extends State<JiljuMainPage> {
  var _index = 0;
  final _pages = [
    const HomePage(),
    const DetailPage(),
    const SyncPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        currentIndex: _index,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
            label: 'Detail',
            icon: Icon(Icons.event_note)
          ),
          BottomNavigationBarItem(
            label: 'Sync',
            icon: Icon(Icons.sync)
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
