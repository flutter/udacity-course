// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:task_05_stateful_widgets/category.dart';
import 'package:task_05_stateful_widgets/unit.dart';

/// Category Route (page).
///
/// This is the "home" page of the Unit Converter. It shows a header bar and
/// a grid of [Categories].
// TODO: Make CategoryRoute a StatefulWidget
class CategoryRoute extends StatelessWidget {
  /// Constructor.
  const CategoryRoute({
    Key key,
  })
      : super(key: key);

  // TODO: Create State object for the CategoryRoute

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
  Widget _buildCategoryWidgets(List<Widget> categories) {
    return new ListView.builder(
      itemBuilder: (BuildContext context, int index) => categories[index],
      itemCount: categories.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Instead of re-creating a list of Categories in every build(),
    // save this as a variable inside the State object and create
    // the list at initialization.
    // This way, you also don't have to pass in the list of categories to
    // _buildCategoryWidgets()
    final categories = <Category>[];

    for (var i = 0; i < _categoryNames.length; i++) {
      categories.add(new Category(
        color: _baseColors[i],
        iconLocation: Icons.cake,
        name: _categoryNames[i],
        units: _retrieveUnitList(_categoryNames[i]),
      ));
    }

    final listView = new Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: _buildCategoryWidgets(categories),
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
