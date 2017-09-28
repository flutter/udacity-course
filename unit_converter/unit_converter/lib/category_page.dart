import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'converter_page.dart';

class CategoryPage extends StatefulWidget {
  // This is the "home" page of the unit converter. It shows a grid of
  // unit categories.
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => new _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<String> categories = [];

  void _navigateToConverter() {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return new Scaffold(
          body: new ConverterPage(),
        );
      },
    ));
  }

  /// Builds a tile that shows unit category information
  Widget _buildCategory(String category) {
    return new Container(
      height: 120.0,
      margin: const EdgeInsets.all(4.0),
      child: new Material(
        child: new RaisedButton(
          color: Colors.lightGreen,
          onPressed: _navigateToConverter,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                category,
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
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
                categories.add(key);
                unitList.add(_buildCategory(key));
//                List<Widget> units = [];
//                for (int i = 0; i < data[key].length; i++) {
//                  if (data[key][i]['base_unit'] != null) {
//                    unitList.add(_buildCategory(key, data[key][i]));
//                  } else {
//                    units.add(_buildUnit(data[key][i]));
//                  }
//                }
//                unitList.add(new Column(
//                  children: units,
//                ));
              }
              // TODO responsive
              return new GridView.count(
                children: unitList,
                crossAxisCount: 2,
              );
            }
            return new Text('Loading');
          }),
    );
  }
}
