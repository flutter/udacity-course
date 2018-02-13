// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:task_05_stateful_widgets/unit.dart';

/// Converter route (page) where users can input amounts to convert.
// TODO: Make ConverterRoute a StatefulWidget
class ConverterRoute extends StatelessWidget {
  /// Color for this [Category]
  final Color color;

  /// This [Category]'s name
  final String name;

  /// [Unit]s for this [Category].
  final List<Unit> units;

  /// Constructor.
  const ConverterRoute({
    Key key,
    @required this.name,
    @required this.color,
    @required this.units,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Here is just a placeholder for a list of mock units
    // TODO: Once the build() function is inside the State object,
    // you'll have to reference this using `widget.units`
    final unitWidgets = units.map((Unit unit) {
      return new Container(
        color: color,
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
