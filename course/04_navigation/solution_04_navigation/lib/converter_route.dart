// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// Converter route (page) where users can input amounts to convert
class ConverterRoute extends StatelessWidget {
  final String name;
  final Color color;

  /// Constructor
  const ConverterRoute({
    Key key,
    this.name,
    this.color,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We'll build the contents of the Converter Route later.
    return new Container();
  }
}
