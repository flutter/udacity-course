// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hello Rainbow Rectangle'),
        ),
        body: HelloRectangle(text: 'Hello from instantiation!'),
      ),
    ),
  );
}

class HelloRectangle extends StatefulWidget {
  final String text;

  HelloRectangle({
    this.text,
  });

  @override
  createState() => _HelloRectangleState();
}

class _HelloRectangleState extends State<HelloRectangle> {
  Color _color = Colors.greenAccent;

  void _generateRandomColor() {
    var random = Random();
    setState(() {
      _color = Color.fromARGB(
        255,
        random.nextInt(255),
        random.nextInt(255),
        random.nextInt(255),
      );
    });
  }

  Widget build(BuildContext context) {
    return Center(
      child: FlatButton(
        onPressed: _generateRandomColor,
        color: _color,
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(fontSize: 40.0),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}