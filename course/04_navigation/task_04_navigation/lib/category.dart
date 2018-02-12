// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:task_04_navigation/converter_route.dart';
import 'package:task_04_navigation/unit.dart';

final _borderRadius = new BorderRadius.circular(4.0);

/// A Category widget for a list of [Unit]s.
class Category extends StatelessWidget {
  final ColorSwatch color;
  final IconData iconLocation;
  final String name;
  final List<Unit> units;

  /// Constructor.
  const Category({
    Key key,
    this.color,
    this.iconLocation,
    this.name,
    this.units,
  })
      : super(key: key);

  /// Navigates to the [ConverterRoute].
  void _navigateToConverter(BuildContext context) {
    // TODO: Using the Navigator, navigate to the Converter Route
    // Specs:
    //  - The Converter Route also has an AppBar, the same color
    //    as the Category widget
    //  - The Title of the AppBar should be the name of the Category and centered
    //  - The Title text style should be the Text Theme's `display1`
    //  - Pass the name, color, and units to the ConverterRoute
  }

  /// Builds a custom widget that shows unit [Category] information.
  ///
  /// This information includes the icon, name, and color for the [Category].
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      height: 100.0,
      child: new Stack(
        children: <Widget>[
          new Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Container(
                width: 70.0,
                margin: const EdgeInsets.all(16.0),
                decoration: new BoxDecoration(
                  borderRadius: _borderRadius,
                  color: color,
                ),
                child: iconLocation != null
                    ? new Icon(
                        iconLocation,
                        size: 60.0,
                      )
                    : null,
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
          new Material(
            // Adds inkwell animation when tapped
            child: new InkWell(
              // TODO update this onTap property to call _navigateToConverter
              onTap: () {
                print('I was tapped!');
              },
              borderRadius: _borderRadius,
            ),
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
