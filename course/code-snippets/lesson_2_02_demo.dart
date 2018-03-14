// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hello Switch'),
        ),
        body: HelloSwitch(),
      ),
    ),
  );
}

class HelloSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Hello!',
            style: TextStyle(fontSize: 36.0),
          ),
          Theme.of(context).platform == TargetPlatform.iOS
              ? CupertinoSwitch(
                  value: true,
                  onChanged: (bool toggled) {},
                )
              : Switch(
                  value: true,
                  onChanged: (bool toggled) {},
                ),
        ],
      ),
    );
  }
}
