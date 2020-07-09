import 'package:flutter/material.dart';

import './pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  // final String _startingProduct = 'Food Paradise';
  bool nightMode = false;
  IconData mode = Icons.wb_sunny;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: !nightMode ? Brightness.light : Brightness.dark,
          primarySwatch: Colors.lightGreen,
          accentColor: Colors.deepPurple),
      home: HomePage(
        setMode: setMode
      ),
    );
  }

  setMode(mode) {
    setState(() => nightMode = !nightMode);
  }
}
