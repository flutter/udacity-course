// You can read about packages here: https://flutter.io/using-packages/
import 'package:flutter/material.dart';
import 'dart:convert';

// We can also import files from relative paths
import 'category.dart';
import 'unit.dart';

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
        // Consider omitting the types for local variables. For more details, see
        // https://www.dartlang.org/guides/language/effective-dart/usage#consider-omitting-the-types-for-local-variables
        for (var i = 0; i < data[key].length; i++) {
          if (data[key][i]['base_unit'] != null) {
            header = Category.buildFromData(key, data[key][i]);
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
  // Loads in JSON asset and builds a static [ListView]
  Widget build(BuildContext context) {
    return new Scaffold(
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
