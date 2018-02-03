import 'package:flutter/material.dart';

const _padding = const EdgeInsets.all(16.0);

void main() {
  runApp(new MaterialApp(
    title: 'Hello Rectangle App Title',
    home: new Scaffold(
      appBar: new AppBar(
        title: new Text('Hello Rectangle App Bar Title'),
      ),
      body: new Rectangle(),
    ),
  ));
}

/// Widget that shows a colored, rectangular container, with centered text
class Rectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: _padding,
      child: new Align(
        alignment: Alignment.topCenter,
        child: new Container(
          color: Colors.greenAccent,
          height: 200.0,
          width: 300.0,
          child: new Center(
            child: new Padding(
              padding: _padding,
              child: new Text(
                'Hello0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0overflow :)',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
