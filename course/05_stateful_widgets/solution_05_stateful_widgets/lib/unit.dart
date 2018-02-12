// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:meta/meta.dart';

/// A unit of measurement is a definite magnitude of a quantity, used as a
/// standard for measurement.
class Unit {
  final String name;
  final double conversion;

  const Unit({
    @required this.name,
    @required this.conversion,
  })
      : assert(name != null),
        assert(conversion != null);
}
