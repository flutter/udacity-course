// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// To keep your imports tidy, follow the ordering guidelines at
// https://www.dartlang.org/guides/language/effective-dart/style#ordering
import 'package:flutter/material.dart';

import 'package:unit_converter/unit.dart';

/// A [Category] keeps track of a list of [Unit]s.
class Category {
  final String name;
  final List<Unit> units;
  final ColorSwatch color;
  final String iconLocation;

  /// Constructor.
  const Category({
    Key key,
    this.name,
    this.units,
    this.color,
    this.iconLocation,
  });
}
