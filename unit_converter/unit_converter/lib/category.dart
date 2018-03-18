// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// To keep your imports tidy, follow the ordering guidelines at
// https://www.dartlang.org/guides/language/effective-dart/style#ordering
import 'package:flutter/material.dart';

import 'package:unit_converter/unit.dart';

typedef void CategoryCallback(Category category);

// We use an underscore to indicate that these variables are private.
// See https://www.dartlang.org/guides/language/effective-dart/design#libraries
const _rowHeight = 100.0;
final _borderRadius = BorderRadius.circular(_rowHeight / 2);

/// A [Category] for a list of [Unit]s.
class Category extends StatelessWidget {
  final String name;
  final List<Unit> units;
  final ColorSwatch color;
  final String iconLocation;
  final CategoryCallback onTap;

  /// Constructor.
  const Category({
    Key key,
    this.name,
    this.units,
    this.color,
    this.iconLocation,
    this.onTap,
  }) : super(key: key);

  /// Builds a custom widget that shows unit [Category] information.
  ///
  /// This information includes the icon, name, and color for the [Category].
  @override
  // This `context` parameter describes the location of this widget in the
  // widget tree. It can be used for grabbing Theme data from the nearest
  // Theme ancestor in the tree. Below, we grab the display1 text theme.
  // See https://docs.flutter.io/flutter/material/Theme-class.html
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return Material(
      color: Colors.transparent,
      child: Container(
        height: _rowHeight,
        child: InkWell(
          borderRadius: _borderRadius,
          highlightColor: color[50],
          splashColor: color[100],
          // We can use either the () => function or the () { function(); }
          // syntax.
          onTap: () => onTap(Category(
            name: name,
            units: units,
            color: color,
          )),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // There are two ways to denote a list: `[]` and `List()`.
              // Prefer to use the literal syntax, i.e. `[]`, instead of `List()`.
              // You can add the type argument if you'd like. We do that here,
              // denoting that the Stack takes in a List of Widget objects.
              // See https://www.dartlang.org/guides/language/effective-dart/usage#do-use-collection-literals-when-possible
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child:
                      iconLocation != null ? Image.asset(iconLocation) : null,
                ),
                Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
