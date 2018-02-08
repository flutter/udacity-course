// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:solution_05_stateful_widgets/unit.dart';

/// Converter route (page) where users can input amounts to convert
class ConverterRoute extends StatefulWidget {
  final String name;
  final Color color;
  final List<Unit> units;

  /// Constructor
  ConverterRoute({
    Key key,
    this.name,
    this.color,
    this.units,
  })
      : super(key: key);

  @override
  _ConverterRouteState createState() => new _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  @override
  Widget build(BuildContext context) {
    // Here is just a placeholder for a list of mock units
    final unitWidgets = widget.units.map((Unit unit) {
      return new Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        color: widget.color,
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
    return new ListView.builder(
      itemBuilder: (BuildContext context, int index) => unitWidgets[index],
      itemCount: unitWidgets.length,
    );
  }
}
