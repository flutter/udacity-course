import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:unit_converter/category.dart';
import 'package:unit_converter/category_route.dart';
import 'package:unit_converter/converter_route.dart';

//
//class Category {
//  const Category({this.title});
//  final String title;
//}
//
//const List<Category> allCategories = const <Category>[
//  const Category(title: 'Length'),
//  const Category(title: 'Mass'),
//  const Category(title: 'Volume'),
//  const Category(title: 'Currency'),
//  const Category(title: 'Area'),
//  const Category(title: 'Digital Storage'),
//];

//class CategoryView extends StatelessWidget {
//  const CategoryView({ Key key, this.category }) : super(key: key);
//
//  final Category category;
//
//  @override
//  Widget build(BuildContext context) {
//    final ThemeData theme = Theme.of(context);
//    return new ListView(
//      children: new List<Widget>.generate(26, (int index) {
//        return new Container(
//          height: 48.0,
//          padding: const EdgeInsets.symmetric(horizontal: 16.0),
//          alignment: AlignmentDirectional.centerStart,
//          child: new Text(
//            'Item $index',
//            style: theme.textTheme.subhead,
//          ),
//        );
//      }).toList(),
//    );
//  }
//}

class BackdropPanel extends StatelessWidget {
  BackdropPanel({
    Key key,
    this.onTap,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.title,
    this.child,
  }) : super(key: key);

  final VoidCallback onTap;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Widget title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new Material(
      elevation: 2.0,
      borderRadius: const BorderRadius.only(
        topLeft: const Radius.circular(16.0),
        topRight: const Radius.circular(16.0),
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: onVerticalDragUpdate,
            onVerticalDragEnd: onVerticalDragEnd,
            onTap: onTap,
            child: new Container(
              height: 48.0,
              padding: const EdgeInsetsDirectional.only(start: 16.0),
              alignment: AlignmentDirectional.centerStart,
              child: new DefaultTextStyle(
                style: Theme.of(context).textTheme.subhead,
                child: title,
              ),
            ),
          ),
          const Divider(
            height: 1.0,
          ),
          new Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class BackdropTitle extends AnimatedWidget {
  BackdropTitle({
    Key key,
    Listenable listenable,
  }) : super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.listenable;
    return new DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.title,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: new Stack(
        children: <Widget>[
          new Opacity(
            opacity: new CurvedAnimation(
              parent: new ReverseAnimation(animation),
              curve: new Interval(0.5, 1.0),
            ).value,
            child: const Text('Select a Category'),
          ),
          new Opacity(
            opacity: new CurvedAnimation(
              parent: animation,
              curve: new Interval(0.5, 1.0),
            ).value,
            child: const Text('Unit Converter'),
          ),
        ],
      ),
    );
  }
}

class Backdrop extends StatefulWidget {
  static const String routeName = '/material/backdrop';
  final backPanel;
//  final contents;
//  final List<Category> categories;

  const Backdrop({
    this.backPanel,
  });

  @override
  _BackdropState createState() => new _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = new GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;
  Category _category;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeCategory(Category category) {
    print('hey man');
    print(category);
    setState(() {
      _category = category;
      _controller.forward();
    });
  }

  bool get _backdropPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropPanelVisibility() {
    _controller.fling(velocity: _backdropPanelVisible ? -2.0 : 2.0);
  }

  double get _backdropHeight {
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
    return renderBox.size.height;
  }

  // By design: the panel can only be opened with a swipe. To close the panel
  // the user must either tap its heading or the backdrop's menu icon.

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    _controller.value -=
        details.primaryDelta / (_backdropHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double panelTitleHeight = 48.0;
    final Size panelSize = constraints.biggest;
    final double panelTop = panelSize.height - panelTitleHeight;

    Animation<RelativeRect> panelAnimation = new RelativeRectTween(
      begin: new RelativeRect.fromLTRB(
          0.0, panelTop, 0.0, panelTop - panelSize.height),
      end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    final ThemeData theme = Theme.of(context);

    return new Container(
      key: _backdropKey,
      color: theme.primaryColor,
      child: new Stack(
        children: <Widget>[
          CategoryRoute(changeCategory: (Category category) {
            changeCategory(category);
          }),
          new PositionedTransition(
            rect: panelAnimation,
            child: new BackdropPanel(
              onTap: _toggleBackdropPanelVisibility,
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              title: new Text(_category != null ? _category.name : 'Length'),
              child: SingleChildScrollView(
                child: _category != null ? new ConverterRoute(
                  name: _category.name,
                  units: _category.units,
                  color: _category.color,
                ) : Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        leading: new IconButton(
          onPressed: _toggleBackdropPanelVisibility,
          icon: new AnimatedIcon(
            icon: AnimatedIcons.close_menu,
            progress: _controller.view,
          ),
        ),
        title: new BackdropTitle(
          listenable: _controller.view,
        ),
      ),
      body: new LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }
}
//
//class BackdropDemo extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      home: new Backdrop(),
//    );
//  }
//}
//
//void main() {
//  runApp(new BackdropDemo());
//}
