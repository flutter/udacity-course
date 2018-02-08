// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:solution_05_stateful_widgets/category.dart';
import 'package:solution_05_stateful_widgets/unit.dart';

const _rightPadding =
    const Padding(padding: const EdgeInsets.only(right: 16.0));
const _bottomPadding =
    const Padding(padding: const EdgeInsets.only(bottom: 16.0));

/// Category Route (page)
///
/// This is the "home" page of the Unit Converter. It shows a header bar and
/// a grid of [Categories].
class CategoryRoute extends StatefulWidget {
  /// Constructor
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

  /// Returns a list of mock [Unit]s
  List<Unit> _retrieveUnitList(String categoryName) {
    var units = <Unit>[];
    for (var i = 0; i < 10; i++) {
      units.add(new Unit(
        name: 'Test $categoryName Unit $i',
        conversion: i.toDouble(),
        description: 'This is a sorry test unit for $categoryName',
      ));
    }
    return units;
  }

  /// Makes the correct number of rows for the Grid View
  List<Widget> _makeGridRows() {
    // Why do we pass in `_categories.toList()` instead of just `_categories`?
    // Widgets are supposed to be deeply immutable objects. We're passing in
    // _categories to this GridView, which changes as we load in each
    // [Category]. So, each time _categories changes, we need to pass in a new
    // list. The .toList() function does this.
    // For more details, see https://github.com/dart-lang/sdk/issues/27755
    final rows = <Widget>[];
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
    return rows;
  }

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _categoryNames.length; i++) {
      _categories.add(new Category(
        name: _categoryNames[i],
        color: _baseColors[i],
        units: _retrieveUnitList(_categoryNames[i]),
        iconLocation: Icons.cake,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final grid = new Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _makeGridRows(),
      ),
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
      body: grid,
    );
  }
}
