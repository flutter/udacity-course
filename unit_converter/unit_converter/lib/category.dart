// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:core';
import 'package:flutter/material.dart';

import 'unit.dart';
import 'converter_route.dart';

/// A Category for a list of units.
class Category extends StatelessWidget {
  final String name;
  final List<Unit> units;
  final ColorSwatch color;
  final IconData icon;

  /// Constructor
  Category({
    this.name,
    this.units,
    this.color,
    this.icon,
  });

  /// Navigates to the unit converter page
  void _navigateToConverter(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return new Scaffold(
          appBar: new AppBar(
            elevation: 1.0,
            title: new Text(
              name,
              style: Theme.of(context).textTheme.display1,
            ),
            centerTitle: true,
            backgroundColor: color,
          ),
          body: new ConverterRoute(
            name: name,
            units: units,
            color: color,
          ),
          // This prevents the onscreen keyboard from affecting the size of the
          // screen, and the space given to widgets.
          // See https://docs.flutter.io/flutter/material/Scaffold/resizeToAvoidBottomPadding.html
          resizeToAvoidBottomPadding: false,
        );
      },
    ));
  }

  /// Builds a tile that shows unit [Category] information
  @override
  Widget build(BuildContext context) {
    // Based on the device size, figure out how to best lay out the list of
    // tiles
    var deviceSize = MediaQuery.of(context).size;
    var appBarSpace = 84.0;
    var height = ((deviceSize.height - appBarSpace) / 4) - (16.0 * 1.25);
    var width = (deviceSize.width / 2) - (16.0 * 1.5);

    if (deviceSize.width > deviceSize.height) {
      height = ((deviceSize.height - appBarSpace) / 2) - (16.0 * 1.5);
      width = (deviceSize.width / 4) - (16.0 * 1.25);
    }

    return new Container(
      height: height,
      width: width,
      child: new Material(
        child: new FlatButton(
          color: color[200],
          onPressed: () => _navigateToConverter(context),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Expanded(
                child: new Icon(
                  icon,
                  size: 40.0,
                ),
              ),
              new Container(
                height: 30.0,
                color: Colors.grey[200],
                child: new Center(
                  child: new Text(
                    name,
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
