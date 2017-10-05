import 'dart:core';
import 'package:flutter/material.dart';

import 'category_route.dart';

void main() {
  runApp(new UnitConverter());
}

class UnitConverter extends StatelessWidget {
  // This widget is the root of your application. The first page we see
  // is a grid of unit categories.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Unit Converter',
      home: new CategoryRoute(footer: false),
    );
  }
}