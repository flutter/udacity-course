// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// You can read about packages here: https://flutter.io/using-packages/
import 'package:flutter/material.dart';
import 'dart:convert';

// This is the first function that is called. It creates a UnitConverter class
void main() {
  runApp(new UnitConverter());
}

// This widget is the root of the application
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

  // Builds a list of Widgets for a portrait screen
  void _buildPortraitListView(
      List<Widget> unitList, Widget header, List<Widget> units) {
    unitList.add(header);
    unitList.add(new Column(
      children: units,
    ));
  }

  // Builds a list of Widgets for a landscape screen
  void _buildLandscapeListView(
      List<Widget> unitList, Widget header, List<Widget> units) {
    unitList.add(new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Expanded(
          flex: 1,
          child: header,
        ),
        new Expanded(
          flex: 2,
          child: new Column(
            children: units,
          ),
        ),
      ],
    ));
  }

  // Builds a responsive [ListView] that changes based on screen orientation
  Widget _buildResponsiveListView(
      Map<String, List<Map<String, dynamic>>> data) {
    return new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var unitList = <Widget>[];
      Widget header;
      for (String key in data.keys) {
        var units = <Widget>[];
        // Consider omitting the types for local variables. For more details on Effective
        // Dart Usage, see https://www.dartlang.org/guides/language/effective-dart/usage
        for (var i = 0; i < data[key].length; i++) {
          if (data[key][i]['base_unit'] != null) {
            header = buildCategory(key, data[key][i]);
          } else {
            units.add(buildUnit(data[key][i]));
          }
        }
        if (constraints.maxHeight > constraints.maxWidth) {
          _buildPortraitListView(unitList, header, units);
        } else {
          _buildLandscapeListView(unitList, header, units);
        }
      }

      // We are using ListView.builder instead of ListView, as it creates
      // children on demand, so it is more efficient
      return new ListView.builder(
        itemBuilder: (BuildContext context, int index) => unitList[index],
        itemCount: unitList.length,
      );
    });
  }

  @override
  // Loads in JSON asset and builds a static [ListView]
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.brown[100],
      body: new Center(
        child: new FutureBuilder(
            future:
                DefaultAssetBundle.of(context).loadString('assets/units.json'),
            builder: (context, snapshot) {
              if (snapshot != null && snapshot.data != null) {
                final decoder = const JsonDecoder();
                Map<String, List<Map<String, dynamic>>> data =
                    decoder.convert(snapshot.data);
                return _buildResponsiveListView(data);
              }
              return new Text('Loading');
            }),
      ),
    );
  }
}

// Dart allows top level functions
// Builds a row that shows unit category information
Widget buildCategory(String category, Map<String, dynamic> baseUnit) {
  var text = new Container(
    margin: const EdgeInsets.only(bottom: 4.0),
    padding: const EdgeInsets.all(10.0),
    color: Colors.transparent,
    child: new Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          category,
          style: new TextStyle(
            color: Colors.pink[800],
            fontSize: 50.0,
            fontFamily: 'Noto Sans',
          ),
        ),
        new Text(
          '1 ${baseUnit['name']} is equal to:',
          style: new TextStyle(
            color: Colors.pink[800],
            fontSize: 20.0,
            fontFamily: 'Noto Sans',
          ),
        ),
      ],
    ),
  );

  return new ConstrainedBox(
    constraints: new BoxConstraints(minHeight: 130.0),
    child: new DecoratedBox(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(colors: [
          Colors.pink[50],
          Colors.brown[100],
        ]),
      ),
      child: text,
    ),
  );
}

// Builds a row that shows unit information
Widget buildUnit(Map<String, dynamic> unit) {
  double conversion = unit['conversion'];
  return new Container(
    margin: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    color: Colors.amber[50],
    child: new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Container(
          child: new Text(
            conversion.floor() == conversion
                ? conversion.toInt().toString()
                : conversion.toString(),
            style: new TextStyle(
              color: Colors.pink[300],
              fontSize: 40.0,
              fontFamily: 'Noto Sans',
            ),
          ),
        ),
        new Text(
          unit['name'],
          style: new TextStyle(
            color: Colors.brown[600],
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Noto Sans',
          ),
        ),
        new Text(
          unit['description'],
          style: new TextStyle(
            color: Colors.brown[600],
            fontSize: 16.0,
            fontFamily: 'Noto Sans',
          ),
        ),
      ],
    ),
  );
}
