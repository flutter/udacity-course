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

// TODO change this color
const _appBarColor = Colors.green;

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
    ColorSwatch(0x33579186, {
      50: Color(0x33579186),
      100: Color(0xFF0ABC9B),
      // 1. Delete these two below, and then type these lines in as part of screencast
      'arrows': Color(0xBB20877E),
      'border': Color(0xFF20877E),
    }),
    ColorSwatch(0xFFFFD28E, {
      50: Color(0xFFFFD28E),
      100: Color(0xFFFFA41C),
      // 1. Add these lines
      'arrows': Color(0x55BC6E0B),
      'border': Color(0xFFBC6E0B),
    }),
    ColorSwatch(0xFFFFB7DE, {
      50: Color(0xFFFFB7DE),
      100: Color(0xFFF94CBF),
      'border': Color(0xFF822A63),
    }),
    ColorSwatch(0xFF8899a8, {
      50: Color(0xFF8899a8),
      100: Color(0xFFa9cae8),
      'border': Color(0xFF395f82),
    }),
    ColorSwatch(200, {
      50: Color(0xFFEAD37E),
      100: Color(0xFFFFE070),
      'border': Color(0xFFD6AD1B),
    }),
    ColorSwatch(200, {
      50: Color(0xFF81A56F),
      100: Color(0xFF7CC159),
      'border': Color(0xFF345125),
    }),
    ColorSwatch(200, {
      50: Color(0xFFd7C0E2),
      100: Color(0xFFCA90E5),
      'border': Color(0xFF6E3F84),
    }),
    ColorSwatch(200, {
      50: Color(0xFFCE9A9A),
      100: Color(0xFFF94D56),
      'border': Color(0xFF912D2D),
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
    final json =
        DefaultAssetBundle.of(context).loadString('assets/regular_units.json');
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
      color: Colors.green[100],
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: _buildCategoryWidgets(deviceSize.height > deviceSize.width),
    );

    if (widget.footer) {
      return listView;
    }

    final appBar = AppBar(
      elevation: 0.0,
      title: Text(
        'Unit Converter'.toUpperCase(),
        style: Theme.of(context).textTheme.title.apply(
              color: Colors.grey[800],
            ),
      ),
      backgroundColor: _appBarColor[100],
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
