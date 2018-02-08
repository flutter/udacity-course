// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// A Category widget for a list of units.
class Category extends StatelessWidget {
  final String name;
  final ColorSwatch color;
  final IconData iconLocation;

  /// Constructor
  const Category({
    Key key,
    this.name,
    this.color,
    this.iconLocation,
  })
      : super(key: key);

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
