// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// To keep your imports tidy, follow the ordering guidelines at
// https://www.dartlang.org/guides/language/effective-dart/style#ordering
import 'package:flutter/material.dart';

import 'package:unit_converter/converter_route.dart';
import 'package:unit_converter/unit.dart';

// We use an underscore to indicate that these variables are private.
// See https://www.dartlang.org/guides/language/effective-dart/design#libraries
<<<<<<< HEAD
const _rowHeight = 100.0;
final _borderRadius = BorderRadius.circular(_rowHeight / 2);
=======
final _borderRadius = BorderRadius.circular(36.0);
>>>>>>> redo converter page

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

  void _showBottomSheet(BuildContext context) {
    final selectCategoryScreen = ConverterRoute(
      name: name,
      units: units,
      color: color,
    );

//    final selectCategoryHeader = Container(
//      alignment: FractionalOffset.bottomLeft,
//      padding: EdgeInsets.symmetric(
//        vertical: 16.0,
//        horizontal: 32.0,
//      ),
//      child: Text(
//        'Select category'.toUpperCase(),
//        style: Theme.of(context).textTheme.subhead.copyWith(
//              fontWeight: FontWeight.w600,
//              color: Colors.grey[700],
//            ),
//      ),
//      decoration: BoxDecoration(
////        borderRadius: BorderRadius.only(
////          topLeft: _bottomSheetBorderRadius,
////          topRight: _bottomSheetBorderRadius,
////        ),
//        color: Colors.white,
//      ),
//    );

    showModalBottomSheet<Null>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: _borderRadius,
          ),
          height: 1000.0,
          child: selectCategoryScreen,
        );
      },
    );
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
      color: Colors.transparent,
      child: Container(
        height: _rowHeight,
        child: InkWell(
          borderRadius: _borderRadius,
          highlightColor: color[50],
          splashColor: color[100],
          // We can use either the () => function or the () { function(); }
          // syntax.
          // TODO we are switching to a Backdrop
          //onTap: () => _showConversionLayer(context),
          onTap: () => _navigateToConverter(context),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // There are two ways to denote a list: `[]` and `List()`.
              // Prefer to use the literal syntax, i.e. `[]`, instead of `List()`.
              // You can add the type argument if you'd like. We do that here,
              // denoting that the Stack takes in a List of Widget objects,
              // with <Widget>[...]
              // See https://www.dartlang.org/guides/language/effective-dart/usage#do-use-collection-literals-when-possible
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child:
                  iconLocation != null ? Image.asset(iconLocation) : null,
                ),
                Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.display1.copyWith(
                      color: Colors.black,
                      fontSize: 24.0,
                    ),
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
