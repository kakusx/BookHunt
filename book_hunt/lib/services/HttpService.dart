import 'dart:io';

import 'package:book_hunt/services/UtilService.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:book_hunt/res/constant.dart';

bool _certificateCheck(X509Certificate cert, String host, int port) => host == 'kakus.cn';

class HttpService {
  Dio dio;
  UtilService util;

  HttpService() {
    this.dio = new Dio();
    this.util = new UtilService();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = _certificateCheck;
    };
  }

  //GET
  Future get(String url) async {
//    print(DATA_SERVER + url);
    Response response = await dio.get(DATA_SERVER + url);
    return checkResult(response);
  }

  //POST
  Future post(String url, Map data) async {
//    print(DATA_SERVER + url);
    var response = await dio.post(DATA_SERVER + url, data: data);
    return checkResult(response);
  }

  //解析结果
  Future checkResult(Response response) async {
    if (response.statusCode == HttpStatus.ok) {
      if (response.data['code'] == 200) {
        return response.data;
      } else {
        util.showToast(response.data['msg'].toString());
        return null;
      }
    } else {
      util.showToast("连接异常-" + response.statusCode.toString());
      return null;
    }
  }
}
