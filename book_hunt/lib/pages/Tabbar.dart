import 'package:book_hunt/components/SearchBarDelegate.dart';
import 'package:book_hunt/pages/BookList.dart';
import 'package:book_hunt/pages/Explore.dart';
import 'package:book_hunt/pages/Favourite.dart';
import 'package:book_hunt/pages/Profile.dart';
import 'package:flutter/material.dart';

class Tabbar extends StatefulWidget {
  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  int _currentIndex = 0;
  var accentColor;

  List _pageNames = ['找书', '发现', '收藏', '我的',];
  List<Widget> _pageList = [BookListPage(), Explore(), Favourite(), Profile()];

  List _chipSelected = [true, true, false, false];
  List _chipBgColors = [Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent];

  @override
  Widget build(BuildContext context) {
    accentColor = Theme.of(context).accentColor;
    return Scaffold(
      appBar: PreferredSize(
        child: tabAppBar(context),
        preferredSize: Size.fromHeight(50),
      ),
      endDrawer: endDrawer(context),
      body: IndexedStack(
        children: _pageList,
        index: _currentIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: this._currentIndex,
          onTap: (int index) {
            setState(() {
              this._currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: accentColor,
          selectedLabelStyle: TextStyle(color: accentColor),
          unselectedItemColor: Colors.black45,
          unselectedLabelStyle: TextStyle(color: Colors.black45),
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

  //region AppBar
  Widget tabAppBar(context){
    return AppBar(
        backgroundColor: Colors.white,
        title: Opacity(
          opacity: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              _pageNames[this._currentIndex],
              style: TextStyle(color: accentColor),
            ),
          ),
        ),
        elevation: 0,
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: accentColor,
              ),
              onPressed: () {
                showSearch(context: context, delegate: SearchBarDelegate());
              }),
          Builder(builder: (context) => IconButton(
            icon: new Icon(Icons.filter_alt_outlined, color: accentColor),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
          ),
        ]);
  }
  //endregion

  //region endDrawer
  Widget endDrawer(context){
    return Drawer(
      child: ListView(
        children: <Widget>[
          Wrap(
              spacing: 8.0, //间隔
              runSpacing: 20.0,//两行之间的间距
              children: <Widget>[
                FilterChip(
                  label: Text("新书库"),
                  selected: _chipSelected[0],
                  selectedColor: Color.fromRGBO(0, 130, 255, 0.2),
                  backgroundColor: Colors.transparent,
                  shape: StadiumBorder(side: BorderSide(color: Colors.black26)),
                  showCheckmark: false,
                  onSelected: (bool value) {
                    setState(() {
                      _chipSelected[0] = value;
                    });
                  },
                ),
                FilterChip(
                  label: Text("可预借"),
                  selected: _chipSelected[1],
                  selectedColor: Color.fromRGBO(0, 130, 255, 0.2),
                  backgroundColor: Colors.transparent,
                  shape: StadiumBorder(side: BorderSide(color: Colors.black26)),
                  showCheckmark: false,
                  onSelected: (bool value) {
                    setState(() {
                      _chipSelected[1] = value;
                    });
                  },
                ),
                FilterChip(
                  label: Text("今日上架"),
                  selected: _chipSelected[2],
                  selectedColor: Color.fromRGBO(0, 130, 255, 0.2),
                  backgroundColor: Colors.transparent,
                  shape: StadiumBorder(side: BorderSide(color: Colors.black26)),
                  showCheckmark: false,
                  onSelected: (bool value) {
                    setState(() {
                      _chipSelected[2] = value;
                    });
                  },
                ),
              ]
          ),
          ListTile(
            title: new Text("识花"),
            trailing: new Icon(Icons.local_florist),
          ),
          ListTile(
            title: new Text("搜索"),
            trailing: new Icon(Icons.search),
          ),
          Divider(),
          ListTile(
            title: new Text("设置"),
            trailing: new Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
  //endregion
}
