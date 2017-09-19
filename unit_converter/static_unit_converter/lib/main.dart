import 'package:flutter/material.dart';

void main() {
  runApp(new UnitConverter());
}

class UnitConverter extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Unit Converter',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new UnitList(title: 'Unit Converter'),
    );
  }
}

class UnitList extends StatelessWidget {
  UnitList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Container(),
    );
  }
}
