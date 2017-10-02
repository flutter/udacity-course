import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'category.dart';
import 'unit.dart';

class CategoryRoute extends StatefulWidget {
  // This is the "home" page of the unit converter. It shows a grid of
  // unit categories.
  CategoryRoute({Key key}) : super(key: key);

  @override
  _CategoryRouteState createState() => new _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  List<Category> categories = [];

  @override
  Widget build(BuildContext context) {
    if (categories.isNotEmpty) {
      // TODO responsive
      return new GridView.count(
        children: categories,
        crossAxisCount: 2,
      );
    }
    return new FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString('assets/units.json'),
        builder: (context, snapshot) {
          if (snapshot != null && snapshot.data != null) {
            final decoder = const JsonDecoder();
            Map<String, List<Map<String, dynamic>>> data =
                decoder.convert(snapshot.data);
            for (String key in data.keys) {
              List<Unit> units = [];
              for (int i = 0; i < data[key].length; i++) {
                units.add(new Unit(data[key][i]['name'],
                    data[key][i]['conversion'], data[key][i]['description']));
              }
              var category = new Category(key, units);
              categories.add(category);
            }
            // TODO responsive
            return new GridView.count(
              children: categories,
              crossAxisCount: 2,
            );
          }
          return new Text('Loading');
        });
  }
}
