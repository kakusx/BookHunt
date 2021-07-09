import 'package:book_hunt/res/constant.dart';
import 'package:book_hunt/services/HttpService.dart';
import 'package:book_hunt/services/UtilService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookPage extends StatefulWidget {
  final Map arguments;

  BookPage({this.arguments});

  @override
  _BookPageState createState() => _BookPageState(book: this.arguments);
}

class _BookPageState extends State<BookPage> {
  final Map book;
  HttpService http = new HttpService();
  UtilService util = new UtilService();

  _BookPageState({this.book});

  String token;
  String ztTypeNames = '';
  String ddTypeNames = '';

  Future<void> getBookType() async {
    token = await util.getStorage('token');
    var queryUrl = 'book/type/' + book['isbn'] + "/" + token;
    var data = await http.get(queryUrl);
    if (data['code'] == -101) {
      Navigator.popAndPushNamed(context, '/login');
    }
    var typeData = data['book_type'];
    print(typeData);
    setState(() {
      ddTypeNames = typeData['dd_type_1'] + ' > ' + typeData['dd_type_2'];
      if (typeData['dd_type_3'] != '') {
        ddTypeNames += ' > ' + typeData['dd_type_3'];
      }
      var ztNames = typeData['ancestry_name'];
      ztNames.forEach((name) {
        ztTypeNames += (ztTypeNames.length > 0 ? ' > ' : '') + name;
      });

    });
  }

  //region build
  @override
  Widget build(BuildContext context) {
    if (ztTypeNames == '') {
      getBookType();
    }
    return Scaffold(
        body: CupertinoScrollbar(
            child: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: CachedNetworkImage(
                height: 300,
                imageUrl: book['img_url_n'] ?? NO_PIC,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  titleSection(),
                  Text(
                    book['abstract'],
                    style: TextStyle(fontSize: 14),
                    softWrap: true,
                  ),
                  Text(
                    book['publisher'] + ", " + book['author'],
                    style: TextStyle(fontSize: 14),
                  ),
                  Text('价格: ' + book['price']),
                  Text('ISBN: ' + book['isbn']),
                  Text('中图法分类: ' + ztTypeNames),
                  Text('当当网分类: ' + ddTypeNames),
                  Text('分类号: ' + book['classno']),
                  Text('推荐分: ' + book['score'].toString()),
                ],
              ),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.arrow_back_rounded,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ));
  }

  //endregion

  //region titleSection
  Widget titleSection() {
    Widget fullName = book['full_title'] != book['title']
        ? Text(
            book['full_title'],
            style: TextStyle(fontSize: 14, color: Colors.black38),
            softWrap: true,
          )
        : Container();
    return Container(
      padding: const EdgeInsets.all(0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    book['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                fullName,
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.favorite_border),
            color: book['fav_ind'] == 'Y' ? Colors.red[500] : Colors.black26,
            onPressed: () {
              setState(() {
                _toggleFav(book);
              });
            },
          ),
        ],
      ),
    );
  }

  //endregion

  //region 切换关注状态
  _toggleFav(Map book) async {
    var isbn = book['isbn'];
    var favInd = book['fav_ind'] == 'Y' ? 'N' : 'Y';
    String token = await util.getStorage('token');
    book['fav_ind'] = favInd;
    var data = await http.post('book/update/' + token, {'isbn': isbn, 'fav_ind': favInd, 'token': token});
    util.toastResult(data);
    print(data);
  }
//endregion
}
