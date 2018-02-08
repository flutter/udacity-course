// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:unit_converter/unit.dart';
import 'package:unit_converter/converter_route.dart';

/// A Category for a list of units.
class Category extends StatelessWidget {
  final String name;
  final List<Unit> units;
  final ColorSwatch color;
  final String iconLocation;

  /// Constructor
  Category({
    this.name,
    this.units,
    this.color,
    this.iconLocation,
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
            backgroundColor: color[100],
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


  /// Builds a custom widget that shows unit [Category] information.
  /// This information includes the icon, name, and color for the [Category].
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Expanded(
              child: new Container(
                color: color[100],
                child:
                    iconLocation != null ? new Image.asset(iconLocation) : null,
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
        // Adds inkwell animation when tapped
        new Material(
          child: new InkWell(
            onTap: () => _navigateToConverter(context),
          ),
          color: Colors.transparent,
        ),
      ],
    );
  }
}
