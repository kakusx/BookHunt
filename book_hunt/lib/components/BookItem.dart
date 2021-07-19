import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:book_hunt/res/constant.dart';

class BookItem extends StatefulWidget {
  final Map data;
  final Key key;

  BookItem({this.data, this.key});

  @override
  _BookItemState createState() => _BookItemState(book: this.data, key: this.key);

}

class _BookItemState extends State<BookItem> {
  final Map book;
  final Key key;

  _BookItemState({this.book, this.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 3, 5, 0),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              bookImg(),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    dense: true,
                    title: Text(
                      book['title'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      book['abstract'],
                      style: TextStyle(fontSize: 13),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('/book', arguments: book);
                    },
                  )
                ],
              )),
            ],
          )),
    );
  }

  Widget bookImg(){
    return Container(
      width: 100,
      padding: EdgeInsets.only(top: 6),
      child: Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          CachedNetworkImage(imageUrl: book['img_url_s'] ?? NO_PIC,),
          Container(
              padding: EdgeInsets.all(isToday()?2:0),
              color: Colors.orangeAccent,
              child: Text(
                isToday()?'New':'',
                style: TextStyle(color: Colors.white, fontSize: 10),
              )),
          Positioned(
            left: 0,
            bottom: 0,
            width: 50,
            height: 15,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bookIcons(),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> bookIcons(){
    List<Widget> icons = [];
    if(book['tabName'] == "[<'Favourite'>]"){
      if(book['active_ind'] =='Y'){
        icons.add(Icon(Icons.check_circle_outline, size: 15, color: Colors.green, ));
      }
    }else{
      if(book['fav_ind'] =='Y'){
        icons.add(Icon(Icons.favorite_border, size: 15, color: Colors.red,));
      }
    }
    if(icons.length == 0){
      icons.add(Container());
    }
    return icons;
  }

  bool isToday(){
    var dbDate = DateTime.parse(book['create_ts']);
    var now = new DateTime.now();
    var dbDateStr = dbDate.year.toString() + dbDate.month.toString() + dbDate.day.toString();
    var nowStr = now.year.toString() + now.month.toString() + now.day.toString();
    return dbDateStr == nowStr;
  }
}
