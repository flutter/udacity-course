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
    fontSize: 50.0,
  );

  Widget _buildCategory(String category, Map<String, dynamic> baseUnit) {
    return new Container(
      height: 120.0,
      margin: const EdgeInsets.all(4.0),
      color: Colors.lightGreen,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            category,
            style: categoryTextStyle,
          ),
          new Text(
            '1 ' + baseUnit['name'] + ' is equal to:',
            style: new TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnit(Map<String, dynamic> unit) {
    double conversion = unit['conversion'];
    double ratio = 1.0 / conversion;

    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      color: Colors.green,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Container(
            child: new Text(
              ratio.floor() == ratio
                  ? ratio.toInt().toString()
                  : ratio.toStringAsFixed(7),
              style: new TextStyle(
                color: Colors.white,
                fontSize: 40.0,
              ),
            ),
          ),
          new Text(
            unit['name'],
            style: new TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          new Text(
            unit['description'],
            style: new TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ],
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
                Map<String, List<Map<String, dynamic>>> data =
                    decoder.convert(snapshot.data);
                List<Widget> unitList = [];
                for (String key in data.keys) {
                  List<Widget> units = [];
                  for (int i = 0; i < data[key].length; i++) {
                    if (data[key][i]['base_unit'] != null) {
                      unitList.add(_buildCategory(key, data[key][i]));
                    } else {
                      units.add(_buildUnit(data[key][i]));
                    }
                  }
                  unitList.add(new Column(
                    children: units,
                  ));
                }
                return new ListView(children: unitList);
              }
              return new Text('Loading');
            }),
      ),
    );
  }
}
