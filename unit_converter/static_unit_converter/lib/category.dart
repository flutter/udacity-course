import 'package:flutter/material.dart';

class Category {
  // Builds a row that shows unit category information
  static Widget buildFromData(String category, Map<String, dynamic> baseUnit) {
    return new Container(
      height: 150.0,
      margin: const EdgeInsets.all(4.0),
      color: Colors.lightGreen,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            category,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 50.0,
            ),
          ),
          new Text(
            '1 ${baseUnit['name']} is equal to:',
            style: new TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
