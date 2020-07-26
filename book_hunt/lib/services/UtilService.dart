import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UtilService {
  void showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void toastResult(Map data){
    if(data != null){
      if(data['code'] == 200){
        showToast('操作成功');
      }else{
        showToast(data['msg']);
      }
    }
  }

  Future getStorage(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  void setStorage(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(value != null){
      prefs.setString(key, value);
    }else{
      prefs.remove(key);
    }
  }
}
