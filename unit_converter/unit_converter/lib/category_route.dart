// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'category.dart';
import 'unit.dart';

class CategoryRoute extends StatefulWidget {
  // This is the "home" page of the unit converter. It shows a grid of
  // unit categories.
  final bool footer;

  CategoryRoute({Key key, this.footer}) : super(key: key);

  @override
  _CategoryRouteState createState() => new _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  // Consider omitting the types for local variables. For more details on Effective
  // Dart Usage, see https://www.dartlang.org/guides/language/effective-dart/usage
  var categories = <Category>[];

  Widget _layOutCategories() {
    if (widget.footer) {
      return new Container(
        color: Colors.green,
        height: 140.0,
        child: new SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: new Row(
            children: categories,
          ),
        ),
      );
    }
    return new GridView.count(
      children: categories,
      crossAxisCount: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isNotEmpty) {
      return _layOutCategories();
    }
    return new FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString('assets/units.json'),
        builder: (context, snapshot) {
          if (snapshot != null && snapshot.data != null) {
            final decoder = const JsonDecoder();
            Map<String, List<Map<String, dynamic>>> data =
                decoder.convert(snapshot.data);
            for (var key in data.keys) {
              List<Unit> units = [];
              for (var i = 0; i < data[key].length; i++) {
                units.add(new Unit(data[key][i]['name'],
                    data[key][i]['conversion'], data[key][i]['description']));
              }
              categories.add(new Category(key, units));
            }
            return _layOutCategories();
          }
          return new Text('Loading');
        });
  }
}
