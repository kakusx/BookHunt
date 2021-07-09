import 'package:book_hunt/model/ScrollEvent.dart';
import 'package:book_hunt/pages/BookList.dart';
import 'package:book_hunt/pages/Explore.dart';
import 'package:book_hunt/pages/Favourite.dart';
import 'package:book_hunt/pages/Profile.dart';
import 'package:book_hunt/utils/EventBusUtil.dart';
import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';

class Tabbar extends StatefulWidget {
  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  int _currentIndex = 0;

  List _pageNames = ['找书', '发现', '收藏', '我的',];
  List _pageList = [BookListPage(), Explore(), Favourite(), Profile()];

  double _scrollHeight = 70;
  double _opacity = 0;

  EventBus eventBus = new EventBus();

  @override
  void initState() {
    super.initState();
    EventBusUtil.getInstance().on<ScrollEvent>().listen((ScrollEvent data) => onListenEvent(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
            title: Opacity(
              opacity: _opacity,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, _scrollHeight, 0, 0),
                child: Text(_pageNames[this._currentIndex]),
              ),
            ),
            elevation: 0,
            brightness: Brightness.dark,
            actions: <Widget>[
              new IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {}),
              new IconButton(icon: Icon(Icons.more_vert, color: Theme.of(context).accentColor), onPressed: () {}),
            ]),
        preferredSize: Size.fromHeight(0),
      ),
      body: this._pageList[this._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: this._currentIndex,
          onTap: (int index) {
            setState(() {
              this._currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).accentColor,
          selectedLabelStyle: TextStyle(color: Theme.of(context).accentColor),
          unselectedItemColor: Colors.black54,
          unselectedLabelStyle: TextStyle(color: Colors.black54),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.auto_stories), label: '找书'),
            BottomNavigationBarItem(icon: Icon(Icons.highlight_outlined), label: '发现'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: '收藏'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '我的'),
          ]),
    );
  }


  onListenEvent(ScrollEvent data) {
    setState(() {
      if(data.scrollHeight <= 0){
        _scrollHeight = 70;
        _opacity = 0;
      }else if(data.scrollHeight > 0 && data.scrollHeight <= 70){
        _scrollHeight = 70 - data.scrollHeight;
        _opacity = (data.scrollHeight + 1) / 71.0;
      }else{
        _scrollHeight = 0;
        _opacity = 1;
      }
    });
  }
}
