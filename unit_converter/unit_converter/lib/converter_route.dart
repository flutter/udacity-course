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

  ConverterRoute({
    Key key,
    this.units,
    this.color,
    this.name,
  })
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
    if (_inputValue != null && _inputValue.isNotEmpty) {
      var outputNum = (double.parse(_inputValue) *
              (_toValue.conversion / _fromValue.conversion))
          .toStringAsPrecision(7);
      // Trim trailing zeros, e.g. 5.500 -> 5.5, 100.0 -> 100
      if (outputNum.contains('.') && outputNum.endsWith('0')) {
        var i = outputNum.length - 1;
        while (outputNum[i] == '0') {
          i -= 1;
        }
        outputNum = outputNum.substring(0, i + 1);
      }
      if (outputNum.endsWith('.')) {
        return outputNum.substring(0, outputNum.length - 1);
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
          width: 130.0,
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
        // This only sets the color of the dropdown menu item, not the dropdown itself
        data: Theme.of(context).copyWith(
          canvasColor: widget.color[300],
        ),
        child: new DropdownButtonHideUnderline(
          child: new DropdownButton(
            value: name,
            items: units,
            onChanged: onChanged,
            style: Theme.of(context).textTheme.subhead.copyWith(
              fontSize: 20.0,
            ),
          ),
        ),
      );
    }

    var chooser = new Container(
      color: widget.color[300],
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Container(
            // You set the color of the dropdown here, not in _createDropdown()
            color: widget.color[300],
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            child: _createDropdown(_fromValue.name, _updateFromConversion),
          ),
          new Container(
            color: widget.color[300],
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: new Icon(
              Icons.arrow_forward,
              color: Colors.black,
            ),
          ),
          new Container(
            color: widget.color[300],
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            child: _createDropdown(_toValue.name, _updateToConversion),
          ),
        ],
      ),
    );

    // This is the widget that accepts text input. In this case, it accepts
    // numbers and calls the onChanged property on update.
    // You can read more about it here: https://flutter.io/text-input
    var convertFrom = new Container(
      color: widget.color[100],
      alignment: FractionalOffset.centerLeft,
      margin: _textMargin,
      padding: _textMargin,
      child: new TextField(
        style: Theme.of(context).textTheme.subhead.copyWith(
          fontSize: 50.0,
        ),
        decoration: new InputDecoration(
          hintText: 'Enter a number',
          hideDivider: true,
          hintStyle: new TextStyle(
            color: Colors.grey[500],
            // See https://github.com/flutter/flutter/issues/11948,
            // Throws an error if you don't specify
            fontSize: 30.0,
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
      margin: _textMargin,
      alignment: FractionalOffset.centerLeft,
      padding: _textMargin,
      child: new Text(
        _convertedValue,
        style: new TextStyle(
          fontSize: 50.0,
        ),
      ),
    );

    var description = new Container(
      color: Colors.white,
      margin: _textMargin,
      child: new Card(
        child: new SingleChildScrollView(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                padding: _textMargin,
                child: new Text(
                  _toValue.name,
                  style: new TextStyle(
                    fontSize: 24.0,
                    color: Colors.grey[900],
                  ),
                ),
              ),
              new Container(
                padding: _textMargin,
                child: new Text(
                  _toValue.description,
                  style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey[900],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    var conversionPage = new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Container(
          margin: const EdgeInsets.only(top: 24.0),
          child: chooser,
        ),
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
        color: Colors.grey[50],
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
