// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:solution_05_stateful_widgets/category.dart';
import 'package:solution_05_stateful_widgets/unit.dart';

/// Category Route (page).
///
/// This is the "home" page of the Unit Converter. It shows a header bar and
/// a grid of [Categories].
class CategoryRoute extends StatefulWidget {
  /// Constructor.
  const CategoryRoute({
    Key key,
  })
      : super(key: key);

  @override
  _CategoryRouteState createState() => new _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  final _categories = <Category>[];

  // Consider omitting the types for local variables. For more details on Effective
  // Dart Usage, see https://www.dartlang.org/guides/language/effective-dart/usage
  static const _appBarColor = const Color(0xFF013487);

  static const _categoryNames = const <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Time',
    'Digital Storage',
    'Energy',
    'Currency',
  ];

  static const _baseColors = const <Color>[
    Colors.teal,
    Colors.orange,
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.yellow,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.red,
  ];

  /// Returns a list of mock [Unit]s.
  List<Unit> _retrieveUnitList(String categoryName) {
    return new List.generate(10, (int i) {
      return new Unit(
        name: 'Test $categoryName Unit $i',
        conversion: i.toDouble(),
      );
    });
  }

  /// Makes the correct number of rows for the list view.
  ///
  /// For portrait, we use a [ListView].
  Widget _buildCategoryWidgets() {
    return new ListView.builder(
      itemBuilder: (BuildContext context, int index) => _categories[index],
      itemCount: _categories.length,
    );
  }

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _categoryNames.length; i++) {
      _categories.add(new Category(
        color: _baseColors[i],
        iconLocation: Icons.cake,
        name: _categoryNames[i],
        units: _retrieveUnitList(_categoryNames[i]),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final listView = new Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: _buildCategoryWidgets(),
    );

    final headerBar = new AppBar(
      elevation: 1.0,
      title: new Text(
        'Unit Converter'.toUpperCase(),
        style: Theme.of(context).textTheme.display1.copyWith(
              color: Colors.white,
            ),
      ),
      centerTitle: true,
      backgroundColor: _appBarColor,
    );

    return new Scaffold(
      appBar: headerBar,
      body: listView,
    );
  }
}
