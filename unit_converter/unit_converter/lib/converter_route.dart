// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'api.dart';
import 'category_route.dart';
import 'unit.dart';

const _padding = const EdgeInsets.all(16.0);

const _horizontalPadding = const EdgeInsets.symmetric(
  horizontal: 16.0,
);

const _bottomMargin = const EdgeInsets.only(
  bottom: 16.0,
);

const _fontSize = 40.0;

/// Converter Route (page) where users can input amounts to convert
class ConverterRoute extends StatefulWidget {
  final String name;
  final List<Unit> units;
  final ColorSwatch color;

  /// Constructor
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
  String _convertedValue = 'Output';
  bool _showCategories = false;

  Future<Null> _updateConversion() async {
    if (_inputValue != null && _inputValue.isNotEmpty) {
      // Our API has a handy convert function, so we can use that for
      // the Currency category
      if (widget.name == apiCategory['name']) {
        var api = new Api();
        var conversion = await api.convert(
            apiCategory['route'], _inputValue, _fromValue.name, _toValue.name);
        setState(() {
          _convertedValue = _format(conversion);
        });
      } else {
        // For the static units, we do the conversion ourselves
        setState(() {
          _convertedValue = _format((double.parse(_inputValue) *
              (_toValue.conversion / _fromValue.conversion)));
        });
      }
    }
  }

  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
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

  void _updateInputValue(String input) {
    setState(() {
      _inputValue = input;
      if (_inputValue == null || _inputValue.isEmpty) {
        _convertedValue = '';
      }
    });
    _updateConversion();
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
    });
    _updateConversion();
  }

  void _updateToConversion(dynamic unitName) {
    setState(() {
      _toValue = _getUnit(unitName);
    });
    _updateConversion();
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
        _toValue = widget.units[1];
      });
    }

    Widget _createDropdown(String name, ValueChanged<dynamic> onChanged) {
      return new Theme(
        // This only sets the color of the dropdown menu item, not the dropdown
        // itself
        data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
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

    var input = new Container(
      color: Colors.white,
      margin: _bottomMargin,
      padding: _horizontalPadding,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // This is the widget that accepts text input. In this case, it
          // accepts numbers and calls the onChanged property on update.
          // You can read more about it here: https://flutter.io/text-input
          new TextField(
            style: Theme.of(context).textTheme.subhead.copyWith(
                  fontSize: _fontSize,
                ),
            decoration: new InputDecoration(
              hintText: 'Enter value',
              hintStyle: new TextStyle(
                color: Colors.grey[500],
                // See https://github.com/flutter/flutter/issues/11948,
                // Throws an error if you don't specify
                fontSize: _fontSize,
              ),
            ),
            // Since we only want numerical input, we use a number keyboard. There
            // are also other keyboards for dates, emails, phone numbers, etc.
            keyboardType: TextInputType.number,
            onChanged: _updateInputValue,
          ),
          new Container(
            // You set the color of the dropdown here, not in _createDropdown()
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            child: _createDropdown(_fromValue.name, _updateFromConversion),
          ),
          new Container(
            color: Colors.white,
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: new Text(
              'to',
              textAlign: TextAlign.left,
            ),
          ),
          new Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            child: _createDropdown(_toValue.name, _updateToConversion),
          ),
        ],
      ),
    );

    var output = new Container(
      color: Colors.white,
      alignment: FractionalOffset.centerLeft,
      padding: _padding,
      margin: _bottomMargin,
      child: new Text(
        _convertedValue,
        style: new TextStyle(
          fontSize: _fontSize,
          color: _convertedValue == 'Output' ? Colors.grey[500] : Colors.black,
        ),
      ),
    );

    var didYouKnow = new Container(
      margin: const EdgeInsets.only(
        bottom: 4.0,
      ),
      child: new Text(
        'Did you know...',
        style: Theme.of(context).textTheme.subhead.copyWith(
              color: Colors.white,
              fontSize: 20.0,
            ),
      ),
    );

    var description = new Container(
      padding: _padding,
      color: widget.color[100],
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Container(
            child: new Text(
              _fromValue.name,
              style: new TextStyle(
                fontSize: 24.0,
                color: Colors.grey[900],
              ),
            ),
          ),
          new Container(
            child: new Text(
              _fromValue.description,
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.grey[900],
              ),
            ),
            margin: _bottomMargin,
          ),
          new Container(
            child: new Text(
              _toValue.name,
              style: new TextStyle(
                fontSize: 24.0,
                color: Colors.grey[900],
              ),
            ),
          ),
          new Container(
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
    );

    var conversionPage = new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          input,
          output,
          didYouKnow,
          description,
        ],
      ),
    );

    return new GestureDetector(
      onTap: _toggleCategories,
      child: new Container(
        color: widget.color[300],
        child: new Stack(
          children: <Widget>[
            new SingleChildScrollView(
            child: conversionPage,
        ),
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
