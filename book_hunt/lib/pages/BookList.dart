import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:book_hunt/services/UtilService.dart';
import 'package:book_hunt/components/BookItem.dart';
import 'package:book_hunt/services/HttpService.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> with SingleTickerProviderStateMixin {

  //region 初始成员变量
  // 当前 tab 索引
  int _tabIndex = 0;

  // 各tab对应的Widget列表
  List<List<Widget>> _listArr = [];

  // ListView当前页码
  List<int> _pageIds = [];

  // ListView 滚动控制器
  List<ScrollController> _controllers = [];

  TabController _tabCtrl;

  // tab 始终保留
  @protected
  bool get wantKeepAlive => true;

  HttpService http = new HttpService();
  UtilService util = new UtilService();
  String token;

  static Widget book(o, String tabName) {
    o['tabName'] = tabName;
    return BookItem(data: o, key: Key(o['isbn']));
  }

  //endregion

  //region 数据接口配置
  List<Map> _tabConfig = [
    {'url': 'book/list/New/', 'getItem': book},
    {'url': 'book/list/Reserve/', 'getItem': book},
    {'url': 'book/favList/', 'getItem': book},
  ];

  //endregion

  //region tabs
  List<Tab> tabs = <Tab>[
    Tab(
      key: Key('Newbook'),
      text: "新书",
    ),
    Tab(
      key: Key('Reserve'),
      text: "预借书",
    ),
    Tab(
      key: Key('Favourite'),
      text: "关注",
    ),
  ];

  //endregion

  //region initState
  @override
  void initState() {
    super.initState();
    //tab切换控制器
    _tabCtrl = new TabController(vsync: this, length: tabs.length);
    _tabCtrl.addListener(() {
      _tabIndex = _tabCtrl.index;
      if (_listArr[_tabIndex].length == 0) {
        _refresh();
      }
    });
    // 添加List滚动控制器，初始化各tab页数据
    this.tabs.forEach((tab) {
      _controllers.add(ScrollController(initialScrollOffset: 0));
      _listArr.add(new List<Widget>());
      _pageIds.add(1);
    });
    _controllers.forEach((ctrl) {
      ctrl.addListener(() {
        if (ctrl.position.pixels == ctrl.position.maxScrollExtent) {
          _pageIds[_tabIndex]++;
          _refresh(clear: false);
        }
      });
    });
    _refreshAll();
  }

  //endregion

  //region dispose
  @override
  void dispose() {
    _tabCtrl.dispose();
    _controllers.forEach((ctrl) {
      ctrl.dispose();
    });
    super.dispose();
  }

  //endregion

  //region build
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
            appBar: AppBar(
              flexibleSpace: SafeArea(
                child: new TabBar(
                  tabs: tabs,
                  isScrollable: true,
                  controller: _tabCtrl,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  labelStyle: new TextStyle(fontSize: 15.0),
                  labelPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  unselectedLabelColor: Colors.black,
                  unselectedLabelStyle: new TextStyle(fontSize: 15.0),
                ),
              ),
            ),
            body: new TabBarView(
                controller: _tabCtrl,
                children: this.tabs.map((tab) {
                  var index = tabs.indexOf(tab);
                  return tabViewContainer(_controllers[index], _listArr[index], tab.key.toString());
                }).toList()),
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.arrow_upward,
              ),
              onPressed: () {
                var controller = _controllers[_tabIndex];
                controller.animateTo(
                  0.0,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 500),
                );
              },
            )));
  }

  //endregion

  //region 页面主体
  Widget tabViewContainer(controller, list, key) {
    return RefreshIndicator(
        onRefresh: _refresh,
        child: Container(
          color: Color.fromRGBO(240, 240, 240, 1),
          child: CupertinoScrollbar(
              child: ListView.builder(
                  key: PageStorageKey(key), //用于保留页面滚动状态
                  controller: controller,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return list[index];
                  })),
        ));
  }

  //endregion

  //region _refreshAll
  _refreshAll() async {
    token = await util.getStorage('token');
    //加载页面数据
    this.tabs.forEach((tab) async {
      await _refresh(index: this.tabs.indexOf(tab));
    });
  }

  //endregion

  //region 刷新列表
  Future<void> _refresh({bool clear: true, int index}) async {
    index = index ?? _tabIndex;
    if (clear) {
      _pageIds[index] = 1;
    }
    //获取新数据
    Map config = _tabConfig[index];
    String page = _pageIds[index].toString();
    var queryUrl = config['url'] + page + "/" + token;
    var data = await http.get(queryUrl);
    if (data['code'] == -101) {
      Navigator.popAndPushNamed(context, '/login');
    }

    var list = _listArr[index];
    if (!mounted) return;
    if (data != null && data['list'].length > 0) {
      setState(() {
        if (clear) {
          list.clear();
        }
        data['list'].forEach((o) {
          String tabName = tabs[index].key.toString();
          list.add(config['getItem'](o, tabName));
        });
      });
    }
  }

//endregion

}
