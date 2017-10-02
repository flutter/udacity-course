import 'package:flutter/material.dart';

class Unit {
  // Builds a row that shows unit information
  static Widget buildFromData(Map<String, dynamic> unit) {
    double conversion = unit['conversion'];
    double ratio = 1.0 / conversion;
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      color: Colors.green,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Container(
            child: new Text(
              ratio.floor() == ratio
                  ? ratio.toInt().toString()
                  : ratio.toStringAsFixed(7),
              style: new TextStyle(
                color: Colors.white,
                fontSize: 40.0,
              ),
            ),
          ),
          new Text(
            unit['name'],
            style: new TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          new Text(
            unit['description'],
            style: new TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
