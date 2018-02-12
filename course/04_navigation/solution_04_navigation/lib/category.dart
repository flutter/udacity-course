// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:solution_04_navigation/converter_route.dart';

final _borderRadius = new BorderRadius.circular(4.0);

/// A Category widget for a list of units.
class Category extends StatelessWidget {
  final String name;
  final ColorSwatch color;
  final IconData iconLocation;

  /// Constructor
  const Category({
    this.name,
    this.color,
    this.iconLocation,
  });

  /// Navigates to the unit converter page
  void _navigateToConverter(BuildContext context) {
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
            color: color,
          ),
        );
      },
    ));
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