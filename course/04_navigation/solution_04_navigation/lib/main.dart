// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// You can read about packages here: https://flutter.io/using-packages/
import 'package:flutter/material.dart';

import 'package:solution_04_navigation/category_route.dart';

void main() {
  runApp(new UnitConverter());
}

/// This widget is the root of your application. The first page we see
/// is a grid of unit categories.
class UnitConverter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Unit Converter',
      home: const CategoryRoute(),
    );
  }
}
