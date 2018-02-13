// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:task_04_navigation/unit.dart';

/// Converter route (page) where users can input amounts to convert.
class ConverterRoute extends StatelessWidget {
  /// Units for this Category
  final List<Unit> units;

  /// Constructor.
  // TODO: pass in the Category's name and color
  // We'll be using them later
  const ConverterRoute({
    Key key,
    @required this.units,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Here is just a placeholder for a list of mock units
    final unitWidgets = units.map((Unit unit) {
      // TODO add the color for this Container
      return new Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            new Text(
              unit.name,
              style: Theme.of(context).textTheme.headline,
            ),
            new Text(
              'Conversion: ${unit.conversion}',
              style: Theme.of(context).textTheme.subhead,
            ),
          ],
        ),
      );
    }).toList();
    return new ListView(
      children: unitWidgets,
    );
  }
}
