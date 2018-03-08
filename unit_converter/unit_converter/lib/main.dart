// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// You can read about packages here: https://flutter.io/using-packages/
import 'package:flutter/material.dart';

import 'package:unit_converter/category_route.dart';

void main() {
  runApp(UnitConverter());
}

/// This widget is the root of our application.
///
/// The first route (page) we see is a grid of unit categories.
class UnitConverter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      theme: ThemeData(
        fontFamily: 'Raleway',
        // This colors the [InputOutlineBorder] when it is selected
        primaryColor: Colors.grey[500],
        textSelectionHandleColor: Colors.green[500],
      ),
      home: CategoryRoute(
        footer: false,
      ),
    );
  }
}
