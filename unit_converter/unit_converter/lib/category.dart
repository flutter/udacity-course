// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:unit_converter/converter_route.dart';
import 'package:unit_converter/unit.dart';

final _borderRadius = new BorderRadius.circular(4.0);

/// A Category for a list of units.
class Category extends StatelessWidget {
  final String name;
  final List<Unit> units;
  final ColorSwatch color;
  final String iconLocation;

  /// Constructor
  const Category({
    Key key,
    this.name,
    this.units,
    this.color,
    this.iconLocation,
  })
      : super(key: key);

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
  // This `context` parameter describes the location of this widget in the
  // widget tree. It can be used for grabbing Theme data from the nearest
  // Theme ancestor in the tree. Below, we grab the display1 text theme.
  Widget build(BuildContext context) {
    return new Container(
      height: 100.0,
      child: new Stack(
        children: <Widget>[
          new Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.all(16.0),
                decoration: new BoxDecoration(
                  borderRadius: _borderRadius,
                  color: color[100],
                ),
                child:
                    iconLocation != null ? new Image.asset(iconLocation) : null,
              ),
              new Container(
                padding: const EdgeInsets.all(16.0),
                child: new Center(
                  child: new Text(
                    name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.display1.copyWith(
                          color: Colors.grey[700],
                          fontSize: 24.0,
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
              borderRadius: _borderRadius,
            ),
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
