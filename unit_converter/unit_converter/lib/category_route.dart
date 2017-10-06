// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:core';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'category.dart';
import 'unit.dart';

class CategoryRoute extends StatefulWidget {
  // This is the "home" page of the unit converter. It shows a grid of
  // unit categories.
  final bool footer;
  final String currentCategory;

  CategoryRoute({Key key, this.footer, this.currentCategory}) : super(key: key);

  @override
  _CategoryRouteState createState() => new _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  // Consider omitting the types for local variables. For more details on Effective
  // Dart Usage, see https://www.dartlang.org/guides/language/effective-dart/usage
  var _categories = <Category>[];

  List<ColorSwatch> _baseColors = [
    new ColorSwatch(500,
        new Map.fromIterables([50, 100], [Colors.blueGrey[50], Colors.blueGrey[100]])),
    new ColorSwatch(500,
        new Map.fromIterables([50, 100], [Colors.amber[50], Colors.amber[100]])),
    new ColorSwatch(500,
        new Map.fromIterables([50, 100], [Colors.brown[50], Colors.brown[100]])),
    new ColorSwatch(500,
        new Map.fromIterables([50, 100], [Colors.pink[50], Colors.pink[100]])),
    new ColorSwatch(500,
        new Map.fromIterables([50, 100], [Colors.orange[50], Colors.orange[100]])),
    new ColorSwatch(500,
        new Map.fromIterables([50, 100], [Colors.deepPurple[50], Colors.deepPurple[100]])),
    new ColorSwatch(500,
        new Map.fromIterables([50, 100], [Colors.green[50], Colors.green[100]])),
  ];
  List<Color> _colors = [
    Colors.blueGrey[50],
    Colors.amber[50],
    Colors.brown[100],
    Colors.pink[50],
    Colors.orange[100],
    Colors.deepPurple[50],
    Colors.green[50],
  ];

  Widget _layOutCategories() {
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
        color: Colors.brown[600],
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
      return _layOutCategories();
    }
    return new FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString('assets/units.json'),
        builder: (context, snapshot) {
          if (snapshot != null && snapshot.data != null) {
            final decoder = const JsonDecoder();
            Map<String, List<Map<String, dynamic>>> data =
                decoder.convert(snapshot.data);
            var ci = 0;
            for (var key in data.keys) {
              List<Unit> units = [];
              for (var i = 0; i < data[key].length; i++) {
                units.add(new Unit(data[key][i]['name'],
                    data[key][i]['conversion'], data[key][i]['description']));
              }
              _categories
                  .add(new Category(key, units, _baseColors[ci % _baseColors.length]));
              ci += 1;
            }
            return _layOutCategories();
          }
          return new Text('Loading');
        });
  }
}
