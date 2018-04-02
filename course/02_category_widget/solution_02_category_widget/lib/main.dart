// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// You can read about packages here: https://flutter.io/using-packages/
import 'package:flutter/material.dart';

// You can use a relative import, i.e. `import 'category.dart;'` or
// a package import, as shown below.
// More details at http://dart-lang.github.io/linter/lints/avoid_relative_lib_imports.html
import 'package:solution_02_category_widget/category.dart';

const _categoryName = 'Cake';
const _categoryIcon = Icons.cake;
const _categoryColor = Colors.green;

/// The function that is called when main.dart is run.
void main() {
  runApp(UnitConverterApp());
}

/// This widget is the root of our application.
/// Currently, we just show one widget in our app.
class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      home: Scaffold(
        backgroundColor: Colors.green[100],
        body: Center(
          child: Category(
            name: _categoryName,
            color: _categoryColor,
            iconLocation: _categoryIcon,
          ),
        ),
      ),
    );
  }
}
