// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'category.dart';
import 'unit.dart';
import 'api.dart';

/// For this app, the only category (endpoint) we retrieve from an API is Currency.
/// If we had more, we could keep a List of categories here.
const apiCategory = const {
  'name': 'Currency',
  'route': 'currency',
};

/// Category Route (page)
///
/// This is the "home" page of the Unit Converter. It shows a header bar and
/// a grid of [Categories].
class CategoryRoute extends StatefulWidget {
  final bool footer;

  CategoryRoute({
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
  var _categories = <Category>[];
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

  static const _icons = const <IconData>[
    Icons.short_text,
    Icons.crop_square,
    Icons.threed_rotation,
    Icons.weekend,
    Icons.access_time,
    Icons.sd_storage,
    Icons.battery_charging_full,
    Icons.attach_money,
  ];

  @override
  Future<Null> didChangeDependencies() async {
    super.didChangeDependencies();
    // We have static unit conversions located in our assets/units.json
    // and we want to also grab up-to-date Currency conversions from the web
    // We only want to load our data in once
    if (_categories.isEmpty) {
      await _retrieveLocalCategories();
      await _retrieveApiCategory();
    }
  }

  /// Retrieves a list of [Categories] and their [Unit]s
  Future<Null> _retrieveLocalCategories() async {
    var json = DefaultAssetBundle.of(context).loadString('assets/units.json');
    final decoder = const JsonDecoder();
    Map<String, List<Map<String, dynamic>>> data = decoder.convert(await json);
    var ci = 0;
    for (var key in data.keys) {
      var units = <Unit>[];
      for (var i = 0; i < data[key].length; i++) {
        units.add(new Unit(
          name: data[key][i]['name'],
          conversion: data[key][i]['conversion'],
          description: data[key][i]['description'],
        ));
      }
      setState(() {
        _categories.add(new Category(
          name: key,
          units: units,
          color: _baseColors[ci % _baseColors.length],
          icon: _icons[ci % _icons.length],
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
        units: null,
        color: _baseColors[_baseColors.length - 1],
        icon: null,
      ));
    });
    var api = new Api();
    var jsonUnits = await api.getUnits(apiCategory['route']);
    // If the API errors out or we have no internet connection, this category
    // remains in placeholder mode (disabled)
    if (jsonUnits != null) {
      var units = <Unit>[];
      for (var unit in jsonUnits) {
        units.add(new Unit(
          name: unit['name'],
          conversion: unit['conversion'].toDouble(),
          description: unit['description'],
        ));
      }
      setState(() {
        _categories.removeLast();
        _categories.add(new Category(
          name: apiCategory['name'],
          units: units,
          color: _baseColors[_baseColors.length - 1],
          icon: _icons[_icons.length - 1],
        ));
      });
    }
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

    // Why do we pass in `_categories.toList()` instead of just `_categories`?
    // Widgets are supposed to be deeply immutable objects. We're passing in
    // _categories to this GridView, which changes as we load in each
    // [Category]. So, each time _categories changes, we need to pass in a new
    // list. The .toList() function does this.
    // For more details, see https://github.com/dart-lang/sdk/issues/27755
    var grid = new Container(
      color: Colors.white,
      padding: widget.footer
          ? const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0)
          : const EdgeInsets.all(16.0),
      child: new Wrap(
        children: _categories.toList(),
        spacing: 16.0,
        runSpacing: 16.0,
      ),
    );

    if (widget.footer) {
      return new SingleChildScrollView(child: grid);
    }

    var headerBar = new AppBar(
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
