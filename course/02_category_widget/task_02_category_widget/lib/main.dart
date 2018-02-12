// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// You can read about packages here: https://flutter.io/using-packages/
import 'package:flutter/material.dart';

import 'package:task_02_category_widget/category.dart';

// TODO: Pass this information into your custom Category widget
const _categoryName = 'Cake';
const _categoryIcon = Icons.cake;
const _categoryColor = Colors.greenAccent;

void main() {
  runApp(new UnitConverter());
}

/// This widget is the root of your application.
/// Currently, we just show one widget in our app.
class UnitConverter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Unit Converter',
      home: new Scaffold(
        backgroundColor: Colors.green[100],
        body: new Center(
          child: new Container(
            height: 100.0,
            // TODO: Determine what properties we'll need to pass into our widget
            child: const Category(),
          ),
        ),
      ),
    );
  }
}
