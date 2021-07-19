import 'package:book_hunt/model/ScrollEvent.dart';
import 'package:book_hunt/utils/EventBusUtil.dart';
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
  String token;
  HttpService http = new HttpService();
  UtilService util = new UtilService();
  List<Widget> _bookList = [];
  int _pageId = 1;

  ScrollController _controller = ScrollController(initialScrollOffset: 0);

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    double scrollHeight = 0;

    _controller.addListener(() {
      scrollHeight = _controller.position.pixels;
      EventBusUtil.getInstance().fire(ScrollEvent(scrollHeight));
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _pageId++;
        _refresh(clear: false);
      }
    });

    return Scaffold(
        body: RefreshIndicator(
            onRefresh: _refresh,
            child: Container(
              color: Color.fromRGBO(247, 248, 249, 1.0),
              child: CupertinoScrollbar(
                  child: ListView.builder(
                      key: PageStorageKey('New'),
                      controller: _controller,
                      itemCount: _bookList.length,
                      itemBuilder: (context, index) {
                        return _bookList[index];
                      })),
            )),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.arrow_upward,
          ),
          onPressed: () {
            var controller = _controller;
            controller.animateTo(
              0.0,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 500),
            );
          },
        ));
  }

  Future<void> _refresh({bool clear: true}) async {
    token = await util.getStorage('token');
    if (clear) {
      _pageId = 1;
    }

    var queryUrl = 'book/list/New/' + _pageId.toString() + "/" + token;
    var data = await http.get(queryUrl);
    if (data['code'] == -101) {
      Navigator.popAndPushNamed(context, '/login');
    }

    if (!mounted) return;
    if (data != null && data['list'].length > 0) {
      setState(() {
        if (clear) {
          _bookList.clear();
        }
        data['list'].forEach((o) {
          o['tabName'] = '';
          _bookList.add(new BookItem(data: o, key: Key(o['isbn'])));
        });
      });
    }
  }
}
