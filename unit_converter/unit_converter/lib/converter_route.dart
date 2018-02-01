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
  double _inputValue;
  String _convertedValue = 'Output';
  bool _showErrorUI = false;
  bool _showValidationError = false;

  Future<Null> _updateConversion() async {
    // Our API has a handy convert function, so we can use that for
    // the Currency category
    if (widget.name == apiCategory['name']) {
      var api = new Api();
      var conversion = await api.convert(apiCategory['route'],
          _inputValue.toString(), _fromValue.name, _toValue.name);
      // API error or not connected to the internet
      if (conversion == null) {
        setState(() {
          _showErrorUI = true;
        });
        return;
      }
      setState(() {
        _convertedValue = _format(conversion);
      });
    } else {
      // For the static units, we do the conversion ourselves
      setState(() {
        _convertedValue = _format(
            _inputValue * (_toValue.conversion / _fromValue.conversion));
      });
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
      if (input == null || input.isEmpty) {
        _convertedValue = 'Output';
      } else {
        // Even though we are using the numerical keyboard, we still have to check
        // for non-numerical input such as '5..0' or '6 -3'
        try {
          var inputDouble = double.parse(input);
          _showValidationError = false;
          _inputValue = inputDouble;
          _updateConversion();
        } on Exception catch (e) {
          print('Error: $e');
          _showValidationError = true;
        }
      }
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
    });
    _updateConversion();
  }

  void _updateToConversion(dynamic unitName) {
    setState(() {
      _toValue = _getUnit(unitName);
    });
    _updateConversion();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.units == null || _showErrorUI) {
      return new Container(
        color: widget.color[200],
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Icon(
              Icons.error_outline,
              size: 180.0,
              color: Colors.white,
            ),
            new Text(
              "Oh no! We can't connect right now!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      );
    }
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
            style: Theme.of(context).textTheme.title,
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
          new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  style: Theme.of(context).textTheme.display1.copyWith(
                        color: _showValidationError
                            ? Colors.red[500]
                            : Colors.black,
                      ),
                  decoration: new InputDecoration(
                    hintText: 'Enter value',
                    hintStyle: Theme.of(context).textTheme.display1.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                  // Since we only want numerical input, we use a number keyboard. There
                  // are also other keyboards for dates, emails, phone numbers, etc.
                  keyboardType: TextInputType.number,
                  onChanged: _updateInputValue,
                ),
              ),
              _showValidationError
                  ? new Icon(
                      Icons.error,
                      color: Colors.red[500],
                    )
                  : new Container(),
            ],
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
        style: Theme.of(context).textTheme.display1.copyWith(
              color:
                  _convertedValue == 'Output' ? Colors.grey[500] : Colors.black,
            ),
      ),
    );

    var didYouKnow = new Container(
      margin: const EdgeInsets.only(
        bottom: 4.0,
      ),
      child: new Text(
        'Did you know...',
        style: Theme.of(context).textTheme.title.copyWith(
              color: Colors.white,
            ),
      ),
    );

    var description = new Container(
      padding: _padding,
      color: widget.color[50],
      margin: _bottomMargin,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Container(
            child: new Text(
              _fromValue.name,
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          new Container(
            child: new Text(
              _fromValue.description,
              style: Theme.of(context).textTheme.title,
            ),
            margin: _bottomMargin,
          ),
          new Container(
            child: new Text(
              _toValue.name,
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          new Container(
            child: new Text(
              _toValue.description,
              style: Theme.of(context).textTheme.title,
            ),
            margin: _bottomMargin * 1.5,
          ),
        ],
      ),
    );

    // Based on the box constraints of our device, figure out how to best
    // lay out our conversion screen
    var conversionScreen = new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxHeight > constraints.maxWidth) {
          return new SingleChildScrollView(
            child: new Padding(
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
            ),
          );
        } else {
          return new SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: new Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: 60.0,
              ),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                    flex: 7,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        input,
                        output,
                      ],
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                  ),
                  new Expanded(
                    flex: 5,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        didYouKnow,
                        description,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );

    var selectCategoryHeader = new Container(
      alignment: FractionalOffset.bottomLeft,
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 32.0,
      ),
      child: new Text(
        'Select category',
        style: Theme.of(context).textTheme.subhead.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
      ),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.only(
          topLeft: new Radius.circular(32.0),
          topRight: new Radius.circular(32.0),
        ),
        color: Colors.white,
      ),
    );

    var selectCategoryScreen = new Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new GestureDetector(
          onTap: () {
            showModalBottomSheet<Null>(
                context: context,
                builder: (BuildContext context) {
                  return new Container(
                    child: new SingleChildScrollView(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          selectCategoryHeader,
                          new CategoryRoute(
                            footer: true,
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          child: selectCategoryHeader,
        ),
      ],
    );

    return new Container(
      color: widget.color[200],
      child: new Stack(
        children: <Widget>[
          conversionScreen,
          selectCategoryScreen,
        ],
      ),
    );
  }
}
