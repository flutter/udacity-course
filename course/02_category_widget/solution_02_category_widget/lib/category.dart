// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

final _borderRadius = new BorderRadius.circular(4.0);

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
          // Adds inkwell animation when tapped
          new Material(
            child: new InkWell(
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
