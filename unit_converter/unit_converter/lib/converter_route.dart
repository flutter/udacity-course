import 'dart:core';
import 'package:flutter/material.dart';

import 'category.dart';
import 'unit.dart';

class ConverterPage extends StatefulWidget {
  final Category category;

  ConverterPage({Key key, this.category}) : super(key: key);

  @override
  _ConverterPageState createState() => new _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  void updateConversion(dynamic data) {
    print('TODO');
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> units = [];
    for (Unit unit in widget.category.units) {
      units.add(new DropdownMenuItem(
        value: unit.name,
        child: new Text(unit.name),
      ));
    }

    // This is the widget that accepts text input. In this case, it accepts
    // numbers. You can read more about it here: https://flutter.io/text-input
    Widget input = new Container(
      width: 300.0,
      child: new TextField(
        keyboardType: TextInputType.number,
        onChanged: null,
      ),
    );

    // This is the dropdown from where you can select unit types
    Widget dropdown = new DropdownButton(
      items: units,
      onChanged: updateConversion,
    );

    Widget convertFrom = new Container(
      color: Colors.green,
      child: new Row(
        children: <Widget>[
          new Expanded(
            flex: 1,
            child: input,
          ),
          new Expanded(
            flex: 2,
            child: dropdown,
          ),
        ],
      ),
    );
    Widget convertTo = new Container(
      color: Colors.lightGreen,
      child: new Row(
        children: [],
      ),
    );

    Widget description = new Container(
      color: Colors.lightGreenAccent,
    );

    return new Container(
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
}
