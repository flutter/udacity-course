// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:task_04_navigation/unit.dart';

/// Converter route (page) where users can input amounts to convert.
///
/// Currently, it just displays a list of mock units.
class ConverterRoute extends StatelessWidget {
  /// Units for this [Category].
  final List<Unit> units;

  /// This [ConverterRoute] handles [Unit]s for a specific [Category].
  // TODO: Pass in the [Category]'s name and color
  const ConverterRoute({
    @required this.units,
  }) : assert(units != null);

  @override
  Widget build(BuildContext context) {
    // Here is just a placeholder for a list of mock units
    final unitWidgets = units.map((Unit unit) {
      // TODO: Set the color for this Container
      return Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              unit.name,
              style: Theme.of(context).textTheme.headline,
            ),
            Text(
              'Conversion: ${unit.conversion}',
              style: Theme.of(context).textTheme.subhead,
            ),
          ],
        ),
      );
    }).toList();
    return ListView(
      children: unitWidgets,
    );
  }
}
