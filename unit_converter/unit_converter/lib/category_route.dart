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

const _appBarColor = Color(0xFF013487);

/// Category Route (page).
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
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  // Consider omitting the types for local variables. For more details on Effective
  // Dart Usage, see https://www.dartlang.org/guides/language/effective-dart/usage
  final _categories = <Category>[];
  static const _baseColors = <ColorSwatch>[
    ColorSwatch(200, {
      50: Color(0xFF579186),
      100: Color(0xFF0abc9b),
      200: Color(0xFF1f685a),
    }),
    ColorSwatch(200, {
      50: Color(0xFFffd28e),
      100: Color(0xFFffa41c),
      200: Color(0xFFbc6e0b),
    }),
    ColorSwatch(200, {
      50: Color(0xFFffb7de),
      100: Color(0xFFf94cbf),
      200: Color(0xFF822a63),
    }),
    ColorSwatch(200, {
      50: Color(0xFF8899a8),
      100: Color(0xFFa9cae8),
      200: Color(0xFF395f82),
    }),
    ColorSwatch(200, {
      50: Color(0xFFead37e),
      100: Color(0xFFffe070),
      200: Color(0xFFd6ad1b),
    }),
    ColorSwatch(200, {
      50: Color(0xFF81a56f),
      100: Color(0xFF7cc159),
      200: Color(0xFF345125),
    }),
    ColorSwatch(200, {
      50: Color(0xFFd7c0e2),
      100: Color(0xFFca90e5),
      200: Color(0xFF6e3f84),
    }),
    ColorSwatch(200, {
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
    final data = await
        DefaultAssetBundle.of(context).loadStructuredData('assets/regular_units.json', new JsonDecoder().convert);
    var ci = 0;
    data.forEach((key, values) {
      setState(() {
        _categories.add(Category(
          name: key,
          units: values.map((unitMap) => Unit.fromJson(unitMap)).toList(),
          color: _baseColors[ci],
          iconLocation: _icons[ci++],
        ));
      });
    });
  }

  /// Retrieves a list of [Categories] and their [Unit]s using streams
  Future<Null> _retrieveLocalCategoriesWithStreams() async {
    final json =
        DefaultAssetBundle.of(context).loadString('assets/regular_units.json');
    var ci = 0;
    var stream = json.asStream()
      .transform(JSON.decoder)
      .expand((jsonMap) =>
        (jsonMap as Map).keys.map((k) => [k, (jsonMap as Map)[k]])
      )
      .map((groupList) =>
        Category(
          name: groupList[0],
          units: groupList[1].map(
            (unitMap) => Unit.fromJson(unitMap)).toList(),
          color: _baseColors[ci],
          iconLocation: _icons[ci++],
        ),
      );
      await for (var category in stream) {
        setState(() => _categories.add(category));
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
  Widget _buildCategoryWidgets(bool portrait) {
    // Why do we pass in `_categories.toList()` instead of just `_categories`?
    // Widgets are supposed to be deeply immutable objects. We're passing in
    // _categories to this GridView, which changes as we load in each
    // [Category]. So, each time _categories changes, we need to pass in a new
    // list. The .toList() function does this.
    // For more details, see https://github.com/dart-lang/sdk/issues/27755
    if (portrait) {
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
    final deviceSize = MediaQuery.of(context).size;
    final listView = Container(
      color: Colors.white,
      padding: widget.footer
          ? EdgeInsets.only(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
              top: 4.0,
            )
          : EdgeInsets.all(16.0),
      child: _buildCategoryWidgets(deviceSize.height > deviceSize.width),
    );

    if (widget.footer) {
      return listView;
    }

    final headerBar = AppBar(
      elevation: 1.0,
      title: Text(
        'Unit Converter'.toUpperCase(),
        style: Theme.of(context).textTheme.display1.copyWith(
              color: Colors.white,
            ),
      ),
      centerTitle: true,
      backgroundColor: _appBarColor,
    );

    return Scaffold(
      appBar: headerBar,
      body: listView,
    );
  }
}
