// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// To keep your imports tidy, follow the ordering guidelines at
// https://www.dartlang.org/guides/language/effective-dart/style#ordering
import 'package:flutter/material.dart';

import 'package:unit_converter/converter_route.dart';
import 'package:unit_converter/unit.dart';

// We use an underscore to indicate that the border radius is private.
// See https://www.dartlang.org/guides/language/effective-dart/design#libraries
final _borderRadius = BorderRadius.circular(4.0);

/// A [Category] for a list of [Unit]s.
class Category extends StatelessWidget {
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
  }) : super(key: key);

  /// Navigates to the [ConverterRoute].
  void _navigateToConverter(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).push(MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1.0,
            title: Text(
              name,
              style: Theme.of(context).textTheme.display1,
            ),
            centerTitle: true,
            backgroundColor: color[100],
          ),
          body: ConverterRoute(
            name: name,
            units: units,
            color: color,
          ),
          // This prevents the onscreen keyboard from affecting the size of the
          // screen, and the space given to widgets.
          // See https://docs.flutter.io/flutter/material/Scaffold/resizeToAvoidBottomPadding.html
          resizeToAvoidBottomPadding: false,
        );
      },
    ));
  }

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
      child: Container(
        height: 100.0,
        child: InkWell(
          // We can use either the () => function or the () { function(); }
          // syntax.
          onTap: () => _navigateToConverter(context),
          borderRadius: _borderRadius,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // There are two ways to denote a list: `[]` and `List()`.
            // Prefer to use the literal syntax, i.e. `[]`, instead of `List()`.
            // You can add the type argument if you'd like. We do that here,
            // denoting that the Stack takes in a List of Widget objects,
            // with <Widget>[...]
            // See https://www.dartlang.org/guides/language/effective-dart/usage#do-use-collection-literals-when-possible
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: _borderRadius,
                  color: color[100],
                ),
                child: iconLocation != null ? Image.asset(iconLocation) : null,
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.display1.copyWith(
                          color: Colors.grey[700],
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
