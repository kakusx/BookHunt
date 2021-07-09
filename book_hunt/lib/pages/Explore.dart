import 'package:book_hunt/model/ScrollEvent.dart';
import 'package:book_hunt/utils/EventBusUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    double scrollHeight = 0;

    var _listScrollCtl = ScrollController(initialScrollOffset: 0);
    _listScrollCtl.addListener(() {
      scrollHeight = _listScrollCtl.position.pixels;
      EventBusUtil.getInstance().fire(ScrollEvent(scrollHeight));
    });
    return RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: () {
          return null;
        },
        child: Container(
            color: Colors.white,
            child: CupertinoScrollbar(
                child: Container(
                    color: Colors.amberAccent,
                    child: ListView(controller: _listScrollCtl, shrinkWrap: true, children: <Widget>[
                    ])))));
  }
}
