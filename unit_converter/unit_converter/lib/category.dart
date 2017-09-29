import 'dart:core';
import 'package:flutter/material.dart';

import 'unit.dart';

class Category extends StatelessWidget {
  final String name;
  final List<Unit> units;
  VoidCallback onPressed;

  Category(this.name, this.units);

  // Builds a tile that shows unit category information
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 120.0,
      margin: const EdgeInsets.all(4.0),
      child: new Material(
        child: new RaisedButton(
          color: Colors.lightGreen,
          onPressed: onPressed,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                name,
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}