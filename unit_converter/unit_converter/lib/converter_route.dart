// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:core';
import 'package:flutter/material.dart';

import 'unit.dart';
import 'category_route.dart';

const _textMargin = const EdgeInsets.all(20.0);

class ConverterRoute extends StatefulWidget {
  final List<Unit> units;

  ConverterRoute({Key key, this.units}) : super(key: key);

  @override
  _ConverterRouteState createState() => new _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  Unit _fromValue;
  Unit _toValue;
  String _inputValue;
  String _convertedValue = '';

  String _updateConversion() {
    if (_inputValue != null) {
      var outputDouble = double.parse(_inputValue) *
          (_toValue.conversion / _fromValue.conversion);
      return outputDouble.toString();
    }
    return '';
  }

  void _updateInputValue(String input) {
    setState(() {
      _inputValue = input;
      _convertedValue = _updateConversion();
    });
  }

  Unit _getUnit(String unitName) {
    for (var unit in widget.units) {
      if (unit.name == unitName) {
        return unit;
      }
    }
    return null;
  }

  void _updateFromConversion(dynamic unitName) {
    setState(() {
      _fromValue = _getUnit(unitName);
      _convertedValue = _updateConversion();
    });
  }

  void _updateToConversion(dynamic unitName) {
    setState(() {
      _toValue = _getUnit(unitName);
      _convertedValue = _updateConversion();
    });
  }

  @override
  Widget build(BuildContext context) {
    var units = <DropdownMenuItem>[];
    for (var unit in widget.units) {
      units.add(new DropdownMenuItem(
        value: unit.name,
        child: new Text(unit.name),
      ));
    }
    if (_fromValue == null) {
      setState(() {
        _fromValue = widget.units[0];
      });
    }
    if (_toValue == null) {
      setState(() {
        _toValue = widget.units[0];
      });
    }

    // This is the widget that accepts text input. In this case, it accepts
    // numbers and calls the onChanged property on update.
    // You can read more about it here: https://flutter.io/text-input
    var input = new Container(
      color: Colors.greenAccent,
      margin: _textMargin,
      child: new TextField(
        style: new TextStyle(
          fontSize: 30.0,
        ),
        // This removes the underline under the input
        decoration: null,
        // Since we only want numerical input, we use a number keyboard. There
        // are also other keyboards for dates, emails, phone numbers, etc.
        keyboardType: TextInputType.number,
        onChanged: _updateInputValue,
      ),
    );

    // This is the dropdown from where you can select unit types
    var fromDropdown = new DropdownButton(
      value: _fromValue.name,
      items: units,
      onChanged: _updateFromConversion,
    );

    // This is the dropdown from where you can select unit types
    var toDropdown = new DropdownButton(
      value: _toValue.name,
      items: units,
      onChanged: _updateToConversion,
    );

    var convertFrom = new Container(
      color: Colors.green,
      child: new Row(
        children: <Widget>[
          new Expanded(
            flex: 1,
            child: input,
          ),
          new Expanded(
            flex: 1,
            child: fromDropdown,
          ),
        ],
      ),
    );

    var convertTo = new Container(
      color: Colors.lightGreen,
      child: new Row(
        children: <Widget>[
          new Expanded(
            flex: 1,
            child: new Container(
              margin: _textMargin,
              child: new Text(
                _convertedValue,
                style: new TextStyle(
                  fontSize: 30.0,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
          new Expanded(
            flex: 1,
            child: toDropdown,
          ),
        ],
      ),
    );

    var description = new Container(
      color: Colors.lightGreenAccent,
      child: new Text(_toValue.description),
    );

    var conversionPage = new Column(
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
    );

    return new Container(
      child: new Stack(
        children: <Widget>[
          conversionPage,
          new Positioned(
            child: new Align(
              alignment: FractionalOffset.bottomCenter,
              child: new Offstage(
                offstage: false,
                child: new CategoryRoute(footer: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
