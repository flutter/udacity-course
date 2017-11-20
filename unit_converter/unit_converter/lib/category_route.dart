// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'category.dart';
import 'unit.dart';
import 'api.dart';

// For this app, the only category (endpoint) we retrieve from an API is Currency.
// If we had more, we could keep a List of categories here.
const apiCategory = const {
  'name': 'Currency',
  'route': 'currency',
};

class CategoryRoute extends StatefulWidget {
  // This is the "home" page of the unit converter. It shows a grid of
  // unit categories.
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

  // Get Currency units from API. This returns a Future object
  // so we put the logic in the .then() section
  void _retrieveApiCategory() {
    var api = new Api();
    api.getUnits(apiCategory['route']).then((jsonUnits) {
      var units = <Unit>[];
      for (var unit in jsonUnits) {
        units.add(new Unit(
          name: unit['name'],
          conversion: unit['conversion'].toDouble(),
          description: unit['description'],
        ));
      }
      _categories.add(new Category(
        name: apiCategory['name'],
        units: units,
        // TODO add these to the API
        color: _baseColors[_baseColors.length - 1],
        icon: _icons[_icons.length - 1],
      ));

      // This updates the screen after API call has returned
      setState(() {});
    });
  }

  Widget _drawCategories() {
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
    return new GridView.count(
      children: _categories,
      crossAxisCount: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_categories.isNotEmpty) {
      return _drawCategories();
    }

    // We have static unit conversions located in our assets/units.json
    // and we want to also grab up-to-date Currency conversions from the web
    var categories = new FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString('assets/units.json'),
      builder: (context, snapshot) {
        if (snapshot == null || snapshot.data == null) {
          return new Text('Loading');
        }
        final decoder = const JsonDecoder();
        Map<String, List<Map<String, dynamic>>> data =
            decoder.convert(snapshot.data);
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
          _categories.add(new Category(
            name: key,
            units: units,
            color: _baseColors[ci % _baseColors.length],
            icon: _icons[ci % _icons.length],
          ));
          ci += 1;
        }


        // Also retrieve Currency category from the API
        _retrieveApiCategory();

        return _drawCategories();
      },
    );

    return categories;
  }
}
