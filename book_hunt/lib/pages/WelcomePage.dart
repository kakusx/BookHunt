import 'package:book_hunt/services/UtilService.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  UtilService util = new UtilService();

  @override
  void initState() {
    super.initState();
//    util.setStorage('token', null);
    _autoLogin();
  }

  //region 自动登录
  _autoLogin() async{
    String token = await util.getStorage('token');
    Future.delayed(Duration(milliseconds: 300), () {
      if (token != null) {
        Navigator.popAndPushNamed(context, '/bookList');
      }else{
        Navigator.popAndPushNamed(context, '/login');
      }
    });
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(250, 250, 250, 1),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
            top: 150,
            width: 250,
            height: 250,
            child: Hero (
                tag: 'logo',
                child: Image.asset("images/bh_logo.png")
            ),
          ),
          Positioned(
            bottom: 50,
            child: Container(
              child: Text('Copyright © kakus.cn', style: TextStyle(fontSize: 12, fontFamily: '',  fontWeight: FontWeight.normal, decoration: TextDecoration.none, color: Colors.black26), ),
            ),
          ),
        ],
      ),
    );
  }
}
