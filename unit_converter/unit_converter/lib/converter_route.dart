// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'unit.dart';
import 'category_route.dart';

const _textMargin = const EdgeInsets.symmetric(
  horizontal: 30.0,
  vertical: 10.0,
);

class ConverterRoute extends StatefulWidget {
  final String name;
  final List<Unit> units;
  final ColorSwatch color;

  ConverterRoute({Key key, this.units, this.color, this.name})
      : super(key: key);

  @override
  _ConverterRouteState createState() => new _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  Unit _fromValue;
  Unit _toValue;
  String _inputValue;
  String _convertedValue = '';
  bool _showCategories = false;

  String _updateConversion() {
    if (_inputValue != null && _inputValue != '') {
      var outputNum = (double.parse(_inputValue) *
              (_toValue.conversion / _fromValue.conversion))
          .toStringAsPrecision(7)
          .toString();
      // Trim trailing zeros, e.g. 5.500, 100.0
      if (outputNum.contains('.') && outputNum.endsWith('0')) {
        while (outputNum.endsWith('0')) {
          outputNum = outputNum.substring(0, outputNum.length - 1);
        }
      }
      if (outputNum.endsWith('.')) {
        outputNum = outputNum.substring(0, outputNum.length - 1);
      }
      return outputNum;
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

  void _toggleCategories() {
    setState(() {
      _showCategories = !_showCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    var units = <DropdownMenuItem>[];
    for (var unit in widget.units) {
      units.add(new DropdownMenuItem(
        value: unit.name,
        child: new Container(
          width: 150.0,
          child: new Text(
            unit.name,
            softWrap: true,
          ),
        ),
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

    Widget _createDropdown(String name, ValueChanged<dynamic> onChanged) {
      return new Theme(
        data: Theme.of(context).copyWith(
              canvasColor: widget.color[50],
            ),
        child: new DropdownButtonHideUnderline(
          child: new DropdownButton(
            value: name,
            items: units,
            onChanged: onChanged,
            style: new TextStyle(
              color: widget.color[600], // 600
              fontSize: 20.0,
              fontFamily: 'Roboto Slab',
            ),
          ),
        ),
      );
    }

    var fromDropdown = _createDropdown(_fromValue.name, _updateFromConversion);

    var toDropdown = _createDropdown(_toValue.name, _updateToConversion);

    var chooser = new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Container(
            color: widget.color[50], //200
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            margin: const EdgeInsets.only(top: 30.0),
            child: fromDropdown,
          ),
          new Text(
            'to',
            style: new TextStyle(
              color: widget.color[200], // 400
              fontFamily: 'Roboto Slab',
            ),
          ),
          new Container(
            color: widget.color[50], //200
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            margin: const EdgeInsets.only(top: 30.0),
            child: toDropdown,
          ),
        ],
      ),
    );

    // This is the widget that accepts text input. In this case, it accepts
    // numbers and calls the onChanged property on update.
    // You can read more about it here: https://flutter.io/text-input
    var convertFrom = new Container(
      color: widget.color[50],
      alignment: FractionalOffset.topLeft,
      padding: _textMargin,
      child: new TextField(
        style: new TextStyle(
          color: widget.color[600], // 400
          fontSize: 50.0,
          fontFamily: 'Roboto Slab',
        ),
        // This removes the underline under the input
        decoration: new InputDecoration(
          hintText: 'Enter a number',
          hideDivider: true,
          hintStyle: new TextStyle(
            color: widget.color[100],
            fontSize: 30.0, // Throws an error if you don't specify
            fontFamily: 'Roboto Slab',
          ),
        ),
        // Since we only want numerical input, we use a number keyboard. There
        // are also other keyboards for dates, emails, phone numbers, etc.
        keyboardType: TextInputType.number,
        onChanged: _updateInputValue,
      ),
    );

    var convertTo = new Container(
      color: widget.color[100],
      alignment: FractionalOffset.topLeft,
      padding: _textMargin,
      child: new Text(
        _convertedValue,
        style: new TextStyle(
          fontSize: 50.0,
          color: widget.color[50], // 300
          fontFamily: 'Roboto Slab',
        ),
      ),
    );

    var description = new Container(
      color: widget.color[50],
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            'What is this unit?',
            style: new TextStyle(
              fontSize: 24.0,
              color: widget.color[100], // 300
              fontFamily: 'Roboto Slab',
            ),
          ),
          new Container(
            child: new Container(
              padding: _textMargin,
              child: new Text(
                _toValue.description,
                style: new TextStyle(
                  color: widget.color[100], // 300
                  fontSize: 20.0,
                  fontFamily: 'Roboto Slab',
                ),
              ),
            ),
          ),
        ],
      ),
    );

    var conversionPage = new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        chooser,
        new Expanded(
          flex: 2,
          child: convertFrom,
        ),
        new Expanded(
          flex: 2,
          child: convertTo,
        ),
        new Expanded(
          flex: 3,
          child: description,
        ),
      ],
    );

    return new GestureDetector(
      onTap: _toggleCategories,
      child: new Container(
        child: new Stack(
          children: <Widget>[
            conversionPage,
            new Align(
              alignment: FractionalOffset.bottomCenter,
              child: new Offstage(
                offstage: !_showCategories,
                child: new CategoryRoute(
                    footer: true, currentCategory: widget.name),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
