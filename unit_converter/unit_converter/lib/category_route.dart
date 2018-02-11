// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:unit_converter/api.dart';
import 'package:unit_converter/category.dart';
import 'package:unit_converter/unit.dart';

/// For this app, the only category (endpoint) we retrieve from an API is Currency.
/// If we had more, we could keep a List of categories here.
const apiCategory = const {
  'name': 'Currency',
  'route': 'currency',
};

const _rightPadding =
    const Padding(padding: const EdgeInsets.only(right: 16.0));
const _bottomPadding =
    const Padding(padding: const EdgeInsets.only(bottom: 16.0));

/// Category Route (page)
///
/// This is the "home" page of the Unit Converter. It shows a header bar and
/// a grid of [Categories].
class CategoryRoute extends StatefulWidget {
  final bool footer;

  const CategoryRoute({
    Key key,
    this.footer,
  })
      : super(key: key);

  @override
  _CategoryRouteState createState() => new _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  // Consider omitting the types for local variables. For more details on Effective
  // Dart Usage, see https://www.dartlang.org/guides/language/effective-dart/usage
  final _categories = <Category>[];
  static const _baseColors = const <ColorSwatch>[
    const ColorSwatch(200, const {
      50: const Color(0xFF579186),
      100: const Color(0xFF0abc9b),
      200: const Color(0xFF1f685a),
    }),
    const ColorSwatch(200, const {
      50: const Color(0xFFffd28e),
      100: const Color(0xFFffa41c),
      200: const Color(0xFFbc6e0b),
    }),
    const ColorSwatch(200, const {
      50: const Color(0xFFffb7de),
      100: const Color(0xFFf94cbf),
      200: const Color(0xFF822a63),
    }),
    const ColorSwatch(200, const {
      50: const Color(0xFF8899a8),
      100: const Color(0xFFa9cae8),
      200: const Color(0xFF395f82),
    }),
    const ColorSwatch(200, const {
      50: const Color(0xFFead37e),
      100: const Color(0xFFffe070),
      200: const Color(0xFFd6ad1b),
    }),
    const ColorSwatch(200, const {
      50: const Color(0xFF81a56f),
      100: const Color(0xFF7cc159),
      200: const Color(0xFF345125),
    }),
    const ColorSwatch(200, const {
      50: const Color(0xFFd7c0e2),
      100: const Color(0xFFca90e5),
      200: const Color(0xFF6e3f84),
    }),
    const ColorSwatch(200, const {
      50: const Color(0xFFce9a9a),
      100: const Color(0xFFf94d56),
      200: const Color(0xFF912d2d),
    }),
  ];

  static const _icons = const <String>[
    'assets/icons/length.png',
    'assets/icons/area.png',
    'assets/icons/volume.png',
    'assets/icons/mass.png',
    'assets/icons/time.png',
    'assets/icons/digital_storage.png',
    'assets/icons/power.png',
    'assets/icons/currency.png',
  ];

  @override
  Future<Null> didChangeDependencies() async {
    super.didChangeDependencies();
    // We have static unit conversions located in our assets/regular_units.json
    // and we want to also grab up-to-date Currency conversions from the web
    // We only want to load our data in once
    if (_categories.isEmpty) {
      await _retrieveLocalCategories();
      await _retrieveApiCategory();
    }
  }

  /// Retrieves a list of [Categories] and their [Unit]s
  Future<Null> _retrieveLocalCategories() async {
    final json =
        DefaultAssetBundle.of(context).loadString('assets/regular_units.json');
    final decoder = const JsonDecoder();
    Map<String, List<Map<String, dynamic>>> data = decoder.convert(await json);
    var ci = 0;
    for (var key in data.keys) {
      final units = <Unit>[];
      for (var i = 0; i < data[key].length; i++) {
        units.add(new Unit(
          name: data[key][i]['name'],
          conversion: data[key][i]['conversion'],
        ));
      }
      setState(() {
        _categories.add(new Category(
          name: key,
          units: units,
          color: _baseColors[ci],
          iconLocation: _icons[ci],
        ));
      });
      ci += 1;
    }
  }

  /// Retrieves a [Category] and its [Unit]s from an API on the web
  Future<Null> _retrieveApiCategory() async {
    // Add a placeholder while we fetch the Currency category using the API
    setState(() {
      _categories.add(new Category(
        name: apiCategory['name'],
        color: _baseColors.last,
      ));
    });
    final api = new Api();
    final jsonUnits = await api.getUnits(apiCategory['route']);
    // If the API errors out or we have no internet connection, this category
    // remains in placeholder mode (disabled)
    if (jsonUnits != null) {
      final units = <Unit>[];
      for (var unit in jsonUnits) {
        units.add(new Unit(
          name: unit['name'],
          conversion: unit['conversion'].toDouble(),
        ));
      }
      setState(() {
        _categories.removeLast();
        _categories.add(new Category(
          name: apiCategory['name'],
          units: units,
          color: _baseColors.last,
          iconLocation: _icons.last,
        ));
      });
    }
  }

  /// Makes the correct number of rows for the Grid View, based on whether the
  /// device is portrait or landscape.
  /// For portrait, we will make a column of four rows, each with two items
  /// For landscape, we will make a column of two rows, each with four items
  List<Widget> _makeGridRows(bool portrait) {
    // Why do we pass in `_categories.toList()` instead of just `_categories`?
    // Widgets are supposed to be deeply immutable objects. We're passing in
    // _categories to this GridView, which changes as we load in each
    // [Category]. So, each time _categories changes, we need to pass in a new
    // list. The .toList() function does this.
    // For more details, see https://github.com/dart-lang/sdk/issues/27755
    final rows = <Widget>[];
    if (portrait) {
      for (var i = 0; i < _categories.length; i += 2) {
        rows.add(new Expanded(
          child: new Row(
            children: <Widget>[
              new Expanded(child: _categories[i]),
              _rightPadding,
              new Expanded(child: _categories[i + 1]),
            ],
          ),
        ));
        if (i + 2 < _categories.length) {
          rows.add(_bottomPadding);
        }
      }
    } else {
      for (var i = 0; i < _categories.length; i += 4) {
        rows.add(new Expanded(
          child: new Row(
            children: <Widget>[
              new Expanded(child: _categories[i]),
              _rightPadding,
              new Expanded(child: _categories[i + 1]),
              _rightPadding,
              new Expanded(child: _categories[i + 2]),
              _rightPadding,
              new Expanded(child: _categories[i + 3]),
            ],
          ),
        ));
        if (i + 4 < _categories.length) {
          rows.add(_bottomPadding);
        }
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    if (_categories.isEmpty) {
      return new Center(
        child: new Container(
          height: 180.0,
          width: 180.0,
          child: new CircularProgressIndicator(),
        ),
      );
    }

    // Based on the device size, figure out how to best lay out the list of
    // tiles into a 2x4 or 4x2 grid.
    final deviceSize = MediaQuery.of(context).size;
    final grid = new Container(
      color: Colors.white,
      padding: widget.footer
          ? const EdgeInsets.only(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
              top: 4.0,
            )
          : const EdgeInsets.all(16.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _makeGridRows(deviceSize.height > deviceSize.width),
      ),
    );

    if (widget.footer) {
      return new Container(
        height: deviceSize.height - 100.0,
        child: grid,
      );
    }

    final headerBar = new AppBar(
      elevation: 1.0,
      title: new Text(
        'Unit Converter'.toUpperCase(),
        style: Theme.of(context).textTheme.display1.copyWith(
              color: Colors.white,
            ),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF013487),
    );

    return new Scaffold(
      appBar: headerBar,
      body: grid,
    );
  }
}
