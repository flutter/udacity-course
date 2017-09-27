import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';

/// This is the first function that is called. It calls the UnitConverter class.
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

  /// Builds a list of Widgets for a portrait screen
  void _buildPortraitListView(
      List<Widget> unitList, Widget header, List<Widget> units) {
    unitList.add(header);
    unitList.add(new Column(
      children: units,
    ));
  }

  /// Builds a list of Widgets for a landscape screen
  void _buildLandscapeListView(
      List<Widget> unitList, Widget header, List<Widget> units) {
    unitList.add(new Row(
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

  /// Builds a responsive [ListView] that changes based on screen orientation
  Widget _buildResponsiveListView(
      Map<String, List<Map<String, dynamic>>> data) {
    return new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      List<Widget> unitList = [];
      Widget header = null;
      for (String key in data.keys) {
        List<Widget> units = [];
        for (int i = 0; i < data[key].length; i++) {
          if (data[key][i]['base_unit'] != null) {
            header = UnitCategory.buildFromData(key, data[key][i]);
          } else {
            units.add(Unit.buildFromData(data[key][i]));
          }
        }
        if (constraints.maxHeight > constraints.maxWidth) {
          _buildPortraitListView(unitList, header, units);
        } else {
          _buildLandscapeListView(unitList, header, units);
        }
      }

      // We are using ListView.builder instead of ListView, as it creates children on demand, so it is more efficient
      return new ListView.builder(
        itemBuilder: (BuildContext context, int index) => unitList[index],
        itemCount: unitList.length,
      );
    });
  }

  @override

  /// Loads in JSON asset and builds a static [ListView]
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
                return _buildResponsiveListView(data);
              }
              return new Text('Loading');
            }),
      ),
    );
  }
}

class Unit extends StatelessWidget {
  /// Builds a row that shows unit information
  static Widget buildFromData(Map<String, dynamic> unit) {
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
    return null;
  }
}

class UnitCategory extends StatelessWidget {
  /// Builds a row that shows unit category information
  static Widget buildFromData(String category, Map<String, dynamic> baseUnit) {
    return new Container(
      height: 150.0,
      margin: const EdgeInsets.all(4.0),
      color: Colors.lightGreen,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            category,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 50.0,
            ),
          ),
          new Text(
            '1 ${baseUnit['name']} is equal to:',
            style: new TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }
}