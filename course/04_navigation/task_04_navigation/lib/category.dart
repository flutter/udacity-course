// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'converter_route.dart';

/// A Category widget for a list of units.
class Category extends StatelessWidget {
  final String name;
  final ColorSwatch color;
  final IconData iconLocation;

  /// Constructor
  Category({
    this.name,
    this.color,
    this.iconLocation,
  });

  /// Navigates to the unit converter page
  void _navigateToConverter(BuildContext context) {
    // TODO: Using the Navigator, navigate to the Converter Route
    // Specs:
    //  - The Converter Route also has an AppBar, the same color
    //    as the Category widget
    //  - The Title of the AppBar should be the name of the Category and centered
    //  - The Title text style should be the Text Theme's `display1`
    //  - Pass the name and color to the ConverterRoute
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
                color: color,
                child: iconLocation != null
                    ? new Icon(
                        iconLocation,
                        size: 60.0,
                      )
                    : null,
              ),
            ),
            new Container(
              height: 40.0,
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
            // TODO: The onTap property should call _navigateToConverter,
            // which takes in a BuildContext as an argument.
            onTap: () {
              print('I was tapped!');
            },
          ),
          color: Colors.transparent,
        ),
      ],
    );
  }
}
