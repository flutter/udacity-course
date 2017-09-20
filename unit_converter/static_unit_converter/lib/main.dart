import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(new UnitConverter());
}

class UnitConverter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Unit Converter',
      home: new UnitList(),
    );
  }
}

class UnitList extends StatelessWidget {
  UnitList({Key key}) : super(key: key);
  TextStyle categoryTextStyle = new TextStyle(
    color: Colors.white,
    fontSize: 20.0,
  );

  Widget buildCategory(String category) {
    return new Container(
      height: 120.0,
      margin: const EdgeInsets.all(4.0),
        color: Colors.lightGreen,
        child: new Text(
          category,
          style: categoryTextStyle,
        ),
    );
  }

  Widget buildUnit(String unit) {
    return new Container(
      height: 80.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      color: Colors.green,
      child: new Text(
        unit,
        style: categoryTextStyle,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new FutureBuilder(
            future:
                DefaultAssetBundle.of(context).loadString('assets/units.json'),
            builder: (context, snapshot) {
              if (snapshot != null && snapshot.data != null) {
                final JsonDecoder decoder = const JsonDecoder();
                Map<String, List<Map<String, dynamic>>> data = decoder.convert(snapshot.data);
                List<Widget> categories = [];
                for (String key in data.keys) {
                  categories.add(buildCategory(key));
                  for (int i = 0; i < data[key].length; i++) {
                    print(data[key][i]['name']);
                    categories.add(buildUnit(data[key][i]['name']));
                  }
                }
                return new ListView(children: categories);
              }
              return new Text('Loading');
            }),
      ),
    );
  }
}
