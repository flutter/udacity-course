// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

// TODO: check if we need to import anything

// TODO: define any constants that are used multiple times, e.g. Padding

/// Category Route (page)
///
/// This is the "home" page of the Unit Converter. It shows a header bar and
/// a grid of [Categories].
class CategoryRoute extends StatelessWidget {
  /// Constructor
  const CategoryRoute({
    Key key,
  })
      : super(key: key);

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

  @override
  Widget build(BuildContext context) {

    // TODO: Create a list of the eight Categories, using the names and colors
    // from above. Use a placeholder icon, such as `Icons.cake` for each
    // Category. We'll add custom icons later.
    final categories = [];

    // TODO: Create a list view of the Categories
    final listView = new Container();

    // TODO: Create an App Bar
    // Specs:
    //  - it is colored _appBarColor
    //  - the text is centered
    final appBar = new AppBar();

    return new Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}
