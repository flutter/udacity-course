// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:meta/meta.dart';

/// Information about a [Unit].
class Unit {
  final String name;
  final double conversion;

  const Unit({
    @required this.name,
    @required this.conversion,
  })
      : assert(name != null),
        assert(conversion != null);

  Unit.fromJson(Map jsonMap) :
    name = jsonMap['name'],
    conversion = jsonMap['conversion'],
    assert(name != null),
    assert(conversion != null);
}