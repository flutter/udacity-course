import 'dart:core';
import 'package:flutter/material.dart';

class ConverterPage extends StatefulWidget {
  ConverterPage({Key key}) : super(key: key);

  @override
  _ConverterPageState createState() => new _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {

  void updateConversion(dynamic data) {
    print('hey;');
  }

  @override
  Widget build(BuildContext context) {
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
}