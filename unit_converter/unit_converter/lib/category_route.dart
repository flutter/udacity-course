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
/// This is the "home" page of the Unit Converter. It shows a grid of
/// [Categories].
class CategoryRoute extends StatefulWidget {
  final bool footer;
  final String currentCategory;

  CategoryRoute({
    Key key,
    this.footer,
    this.currentCategory,
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
    Colors.grey,
    Colors.blueGrey,
    const ColorSwatch(300, const {
      50: const Color(0xFFF2F7FF),
      100: const Color(0xFFe0eaf9),
      200: const Color(0xFFcfe1fc),
      300: const Color(0xFFb6cdef),
    }),
    const ColorSwatch(300, const {
      50: const Color(0xFFd2efee),
      100: const Color(0xFFbcf2eb),
      200: const Color(0xFF9de0d7),
      300: const Color(0xFF84d8cd),
    }),
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
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
    if (json == null) {
      // TODO error UI
    }
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
    var api = new Api();
    var jsonUnits = await api.getUnits(apiCategory['route']);
    var units = <Unit>[];
    for (var unit in jsonUnits) {
      units.add(new Unit(
        name: unit['name'],
        conversion: unit['conversion'].toDouble(),
        description: unit['description'],
      ));
    }
    setState(() {
      _categories.add(new Category(
        name: apiCategory['name'],
        units: units,
        // TODO add these to the API
        color: Colors.red,
        icon: Icons.attach_money,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_categories.isEmpty) {
      // TODO loading text
      return new Text('Loading');
    }
    if (widget.footer) {
      // Reorganize the list so that the one we selected is first and highlighted
      for (var i = 0; i < _categories.length; i++) {
        if (_categories[i].name == widget.currentCategory) {
          var firstHalf = _categories.sublist(0, i);
          _categories = _categories.sublist(i, _categories.length);
          _categories.addAll(firstHalf);
          break;
        }
      }
      return new Container(
        color: Colors.grey[600],
        height: 140.0,
        child: new SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: new Row(
            children: _categories,
          ),
        ),
      );
    }
    // TODO responsive
    // Why do we pass in `_categories.toList()` instead of just `_categories`?
    // Widgets are supposed to be deeply immutable objects. We're passing in
    // _categories to this GridView, which changes as we load in each
    // [Category]. So, each time _categories changes, we need to pass in a new
    // list. The .toList() function does this.
    // For more details, see https://github.com/dart-lang/sdk/issues/27755
    return new GridView.count(
      children: _categories.toList(),
      crossAxisCount: 2,
    );
  }
}
