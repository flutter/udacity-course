// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Hello Rectangle',
    home: Scaffold(
      body: HelloRectangle(),
    ),
  ));
}

class HelloRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var container = Container(
      color: Colors.purple,
    );
    return Container(
      padding: EdgeInsets.only(
        top: 64.0,
        left: 32.0,
        bottom: 32.0,
        right: 32.0,
      ),
      child: container,
    );
  }
}

/// Example of a widget with the `children` property.
var container = Column(
  children: <Widget>[
    Text('Hello!'),
    Text('Hello!'),
    Text('Hello!'),
    Text('Hello!'),
  ],
);
