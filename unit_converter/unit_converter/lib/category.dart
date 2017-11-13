// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:core';
import 'package:flutter/material.dart';

import 'unit.dart';
import 'converter_route.dart';

class Category extends StatelessWidget {
  final String name;
  final List<Unit> units;
  final ColorSwatch color;
  final IconData icon;

  Category({
    this.name,
    this.units,
    this.color,
    this.icon,
  });

  void _navigateToConverter(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return new Scaffold(
          body: new ConverterRoute(units: units, color: color, name: name),
          // This prevents the onscreen keyboard from affecting the size of the
          // screen, and the space given to widgets.
          // See https://docs.flutter.io/flutter/material/Scaffold/resizeToAvoidBottomPadding.html
          resizeToAvoidBottomPadding: false,
        );
      },
    ));
  }

  // Builds a tile that shows unit category information
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 120.0,
      margin: const EdgeInsets.all(4.0),
      child: new Material(
        child: new RaisedButton(
          color: color[50],
          onPressed: () => _navigateToConverter(context),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Icon(
                icon,
                size: 70.0,
              ),
              new Text(
                name,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Noto Sans',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
