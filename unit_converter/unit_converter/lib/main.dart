import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(new UnitConverter());
}

class UnitConverter extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Unit Converter',
      home: new CategoryPage(),
    );
  }
}

class ConverterPage extends StatefulWidget {
  ConverterPage({Key key}) : super(key: key);

  @override
  _ConverterPageState createState() => new _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}

class CategoryPage extends StatefulWidget {
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
          body: _buildConverterInput(),
        );
      },
    ));
  }

  TextStyle categoryTextStyle = new TextStyle(
    color: Colors.white,
    fontSize: 30.0,
  );

  void updateConversion(dynamic data) {
    print('hey;');
  }

  Widget _buildConverterInput() {
    List<DropdownMenuItem> units = [];
    units.add(new DropdownMenuItem(
      value: 'value',
      child: new Container(),
    ));
    Widget dropdown = new DropdownButton(
      items: units,
      onChanged: updateConversion,
    );
    Widget convertFrom = new Container(
      color: Colors.pink,
      child: new Row(
        children: <Widget>[
          new Container(
              height: 50.0,
              width: 300.0,
              child: new TextField(
                keyboardType: TextInputType.number,
                onChanged: null,
              )),
          dropdown,
        ],
      ),
    );
    Widget convertTo = new Container(
      color: Colors.orange,
      child: new Row(
        children: [],
      ),
    );

    Widget description = new Container(
      color: Colors.blue,
    );

    return new Container(
      color: Colors.pink,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Expanded(
            flex: 1,
            child: convertFrom,
          ),
          new Expanded(
            flex: 1,
            child: convertTo,
          ),
          new Expanded(
            flex: 1,
            child: description,
          ),
        ],
      ),
    );
  }

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
                style: categoryTextStyle,
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
              return new GridView.count(children: unitList, crossAxisCount: 2);
            }
            return new Text('Loading');
          }),
    );
  }
}
