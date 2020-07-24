import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:book_hunt/res/constant.dart';

bool _certificateCheck(X509Certificate cert, String host, int port) => host == 'kakus.cn';

class HttpService {
  Dio dio;

  HttpService() {
    this.dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = _certificateCheck;
    };
  }

  //GET
  Future get(String url, {String dataKey = 'list'}) async {
    print(url + AUTH_KEY);
    Response response = await dio.get(DATA_SERVER + url + AUTH_KEY);
    return await parseResult(response, dataKey);
  }

  //POST
  Future post(String url, Map data, {String dataKey = 'result'}) async {
    print(url + AUTH_KEY);
    var response = await dio.post(DATA_SERVER + url + AUTH_KEY, data: data);
    return await parseResult(response, dataKey);
  }

  //解析结果
  Future parseResult(Response response, String key) async {
    if (response.statusCode == HttpStatus.ok) {
      var data = await response.data[key];
      return data;
    } else {
      return null;
    }
  }
}
