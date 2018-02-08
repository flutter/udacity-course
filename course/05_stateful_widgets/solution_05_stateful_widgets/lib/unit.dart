// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:meta/meta.dart';

/// Information about a [Unit]
class Unit {
  final String name;
  final double conversion;
  final String description;

  const Unit({
    @required this.name,
    this.conversion,
    @required this.description,
  })
      : assert(name != null),
        assert(description != null);
}