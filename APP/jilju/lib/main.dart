import 'package:flutter/material.dart';

void main() {
  runApp(const Jilju());
}

class Jilju extends StatelessWidget {
  const Jilju({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jilju',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const JiljuMainPage(title: 'Jilju'),
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
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(
          '$_index page',
          style: const TextStyle(fontSize: 40),
        ),
      ),
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
