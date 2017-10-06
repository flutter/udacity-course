// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:core';
import 'package:flutter/material.dart';

import 'unit.dart';
import 'converter_route.dart';

class Category extends StatelessWidget {
  final String name;
  final List<Unit> units;

  Category(this.name, this.units);

  void _navigateToConverter(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return new Scaffold(
          body: new ConverterRoute(units: units),
        );
      },
    ));
  }

  // Builds a tile that shows unit category information
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 120.0,
      width: 120.0,
      margin: const EdgeInsets.all(4.0),
      child: new Material(
        child: new RaisedButton(
          color: Colors.lightGreen,
          onPressed: () => _navigateToConverter(context),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                name,
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}