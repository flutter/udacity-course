import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'converter_route.dart';
import 'category.dart';
import 'unit.dart';

class CategoryPage extends StatefulWidget {
  // This is the "home" page of the unit converter. It shows a grid of
  // unit categories.
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => new _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Category> categories = [];

  void _navigateToConverter(Category category) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return new Scaffold(
          body: new ConverterPage(category: category),
        );
      },
    ));
  }

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
            final JsonDecoder decoder = const JsonDecoder();
            Map<String, List<Map<String, dynamic>>> data =
                decoder.convert(snapshot.data);
            List<Widget> categoryList = [];
            for (String key in data.keys) {
              List<Unit> units = [];
              for (int i = 0; i < data[key].length; i++) {
                units.add(new Unit(data[key][i]['name'],
                    data[key][i]['conversion'], data[key][i]['description']));
              }
              Category category = new Category(key, units);
              category.onPressed = () => _navigateToConverter(category);
              categories.add(category);
              categoryList.add(category);
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
