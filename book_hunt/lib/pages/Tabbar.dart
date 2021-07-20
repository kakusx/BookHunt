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

  List _chipSelected = [true, false, false, false];

  @override
  Widget build(BuildContext context) {
    accentColor = Theme.of(context).accentColor;
    return Scaffold(
      extendBodyBehindAppBar: true,
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
        brightness: Brightness.light,
        title: Text(
          _pageNames[_currentIndex],
          style: TextStyle(color: accentColor),
        ),
        elevation: 0,
        actions: <Widget>[
          _currentIndex==0 ? IconButton(
              icon: Icon(Icons.search, color: accentColor,),
              onPressed: () => showSearch(context: context, delegate: SearchBarDelegate())
              ): Container(),
          Builder(builder: (context) => _currentIndex==0?IconButton(
            icon: new Icon(Icons.filter_alt_outlined, color: accentColor),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ):Container(),
          ),
        ]);
  }
  //endregion

  Widget drawerFilterChip(name, index){
    return FilterChip(
      label: Text(name),
      labelStyle: TextStyle(
          color: _chipSelected[index]
              ? accentColor
              : Colors.black26),
      selected: _chipSelected[index],
      selectedColor: Color.fromRGBO(0, 130, 255, 0.2),
      backgroundColor: Colors.transparent,
      shape: StadiumBorder(side: BorderSide(color: _chipSelected[index]?accentColor:Colors.black12)),
      showCheckmark: false,
      onSelected: (bool value) {
        setState(() {
          _chipSelected[index] = value;
        });
      },
    );
  }

  //region endDrawer
  Widget endDrawer(context){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
        children: <Widget>[
          ListTile(title: new Text("筛选"), contentPadding: EdgeInsets.fromLTRB(15, 0, 10, 0), dense: true,),
          Divider(),
          Wrap(
              spacing: 8.0, //间隔
              runSpacing: 10.0,//两行之间的间距
              children: <Widget>[
                drawerFilterChip('可预借', 0),
                drawerFilterChip('新书', 1),
                drawerFilterChip('今日上架', 2),
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
          OutlinedButton(child: const Text('确认'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 1, color: accentColor),
              ),
              onPressed: () => Navigator.pop(context))
        ],
      ),
    );
  }
  //endregion
}
