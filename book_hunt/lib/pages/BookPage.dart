import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:book_hunt/res/constant.dart';
import 'package:book_hunt/services/HttpService.dart';

class BookPage extends StatefulWidget {
  final Map arguments;

  BookPage({this.arguments});

  @override
  _BookPageState createState() => _BookPageState(book: this.arguments);
}

class _BookPageState extends State<BookPage> {
  final Map book;
  HttpService http = new HttpService();

  _BookPageState({this.book});

  //region build
  @override
  Widget build(BuildContext context) {
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
                  Text('分类号: ' + book['classno']),
                  Text('推荐分: ' + book['score'].toString()),
                ],
              ),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.arrow_back_ios,
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
  _toggleFav(Map book) {
    var isbn = book['isbn'];
    var favInd = book['fav_ind'] == 'Y' ? 'N' : 'Y';
    book['fav_ind'] = favInd;
    http.post('book/update', {'isbn': isbn, 'fav_ind': favInd});
  }
//endregion
}
