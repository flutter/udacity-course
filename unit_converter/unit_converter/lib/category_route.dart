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
///
/// If we had more, we could keep a List of categories here.
const apiCategory = {
  'name': 'Currency',
  'route': 'currency',
};

final _backgroundColor = Colors.green[100];

/// Category Route (page).
///
/// This is the "home" page of the Unit Converter. It shows a header bar and
/// a grid of [Categories].
class CategoryRoute extends StatefulWidget {
  final bool footer;

  const CategoryRoute({
    this.footer,
  });

  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  // Consider omitting the types for local variables. For more details on Effective
  // Dart Usage, see https://www.dartlang.org/guides/language/effective-dart/usage
  final _categories = <Category>[];
  static const _baseColors = <ColorSwatch>[
    ColorSwatch(0xFF579186, {
      50: Color(0xFF579186),
      100: Color(0xFF0abc9b),
      200: Color(0xFF1f685a),
    }),
    ColorSwatch(0xFFffd28e, {
      50: Color(0xFFffd28e),
      100: Color(0xFFffa41c),
      200: Color(0xFFbc6e0b),
    }),
    ColorSwatch(0xFFffb7de, {
      50: Color(0xFFffb7de),
      100: Color(0xFFf94cbf),
      200: Color(0xFF822a63),
    }),
    ColorSwatch(0xFF8899a8, {
      50: Color(0xFF8899a8),
      100: Color(0xFFa9cae8),
      200: Color(0xFF395f82),
    }),
    ColorSwatch(0xFFead37e, {
      50: Color(0xFFead37e),
      100: Color(0xFFffe070),
      200: Color(0xFFd6ad1b),
    }),
    ColorSwatch(0xFF81a56f, {
      50: Color(0xFF81a56f),
      100: Color(0xFF7cc159),
      200: Color(0xFF345125),
    }),
    ColorSwatch(0xFFd7c0e2, {
      50: Color(0xFFd7c0e2),
      100: Color(0xFFca90e5),
      200: Color(0xFF6e3f84),
    }),
    ColorSwatch(0xFFce9a9a, {
      50: Color(0xFFce9a9a),
      100: Color(0xFFf94d56),
      200: Color(0xFF912d2d),
    }),
  ];

  static const _icons = <String>[
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
    // We have static unit conversions located in our
    // assets/data/regular_units.json
    // and we want to also grab up-to-date Currency conversions from the web
    // We only want to load our data in once
    if (_categories.isEmpty) {
      await _retrieveLocalCategories();
      await _retrieveApiCategory();
    }
  }

  /// Retrieves a list of [Categories] and their [Unit]s
  Future<Null> _retrieveLocalCategories() async {
    final json = DefaultAssetBundle
        .of(context)
        .loadString('assets/data/regular_units.json');
    final decoder = JsonDecoder();
    final data = decoder.convert(await json);
    var ci = 0;
    for (var key in data.keys) {
      final units = <Unit>[];
      for (var i = 0; i < data[key].length; i++) {
        units.add(Unit.fromJson(data[key][i]));
      }
      setState(() {
        _categories.add(Category(
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
      _categories.add(Category(
        name: apiCategory['name'],
        color: _baseColors.last,
      ));
    });
    final api = Api();
    final jsonUnits = await api.getUnits(apiCategory['route']);
    // If the API errors out or we have no internet connection, this category
    // remains in placeholder mode (disabled)
    if (jsonUnits != null) {
      final units = <Unit>[];
      for (var unit in jsonUnits) {
        units.add(Unit(
          name: unit['name'],
          conversion: unit['conversion'].toDouble(),
        ));
      }
      setState(() {
        _categories.removeLast();
        _categories.add(Category(
          name: apiCategory['name'],
          units: units,
          color: _baseColors.last,
          iconLocation: _icons.last,
        ));
      });
    }
  }

  /// Makes the correct number of rows for the list view, based on whether the
  /// device is portrait or landscape.
  ///
  /// For portrait, we use a [ListView]
  /// For landscape, we use a [GridView]
  Widget _buildCategoryWidgets(Orientation deviceOrientation) {
    // Why do we pass in `_categories.toList()` instead of just `_categories`?
    // Widgets are supposed to be deeply immutable objects. We're passing in
    // _categories to this GridView, which changes as we load in each
    // [Category]. So, each time _categories changes, we need to pass in a new
    // list. The .toList() function does this.
    // For more details, see https://github.com/dart-lang/sdk/issues/27755
    if (deviceOrientation == Orientation.portrait) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) => _categories[index],
        itemCount: _categories.length,
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.0,
        children: _categories,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_categories.isEmpty) {
      return Center(
        child: Container(
          height: 180.0,
          width: 180.0,
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Based on the device size, figure out how to best lay out the list
    // You can also use MediaQuery.of(context).size to check orientation
    assert(debugCheckHasMediaQuery(context));
    final listView = Container(
      color: _backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: _buildCategoryWidgets(MediaQuery.of(context).orientation),
    );

    if (widget.footer) {
      return listView;
    }

    final appBar = AppBar(
      elevation: 0.0,
      title: Text(
        'Unit Converter'.toUpperCase(),
        style: Theme.of(context).textTheme.title,
      ),
      backgroundColor: _backgroundColor,
      leading: Icon(
        Icons.clear,
        color: Colors.grey[800],
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}
