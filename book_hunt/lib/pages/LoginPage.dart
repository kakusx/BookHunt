import 'package:flutter/material.dart';
import 'package:book_hunt/services/HttpService.dart';
import 'package:book_hunt/services/UtilService.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  HttpService http = new HttpService();
  UtilService util = new UtilService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Padding(
                padding: EdgeInsets.fromLTRB(24, 75, 24, 10),
                child: Form(
                    key: _formKey, //设置globalKey，用于后面获取FormState
                    autovalidate: true, //开启自动校验
                    child: Column(children: <Widget>[
                      Hero (
                          tag: 'logo',
                          child: Image.asset("images/bh_logo.png", width: 200, height: 200,)
                      ),
                      TextFormField(
                          autofocus: true,
                          controller: _unameController,
                          decoration: InputDecoration(labelText: "用户名", hintText: "用户名或邮箱", icon: Icon(Icons.person)),
                          // 校验用户名
                          validator: (v) {
                            return v.trim().length > 0 ? null : "用户名不能为空";
                          }),
                      TextFormField(
                          controller: _pwdController,
                          decoration: InputDecoration(labelText: "密码", hintText: "您的登录密码", icon: Icon(Icons.lock)),
                          obscureText: true,
                          //校验密码
                          validator: (v) {
                            return v.trim().length > 5 ? null : "密码不能少于6位";
                          }),
                      // 登录按钮
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                padding: EdgeInsets.all(15.0),
                                child: Text("登录"),
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                onPressed: () async {
                                  // 通过_formKey.currentState 获取FormState后，
                                  // 调用validate()方法校验用户名密码是否合法，校验
                                  // 通过后再提交数据。
                                  if ((_formKey.currentState as FormState).validate()) {
                                    //验证通过提交数据
                                    var result = await http.post('login', {'user': _unameController.text, 'pwd': _pwdController.text});
                                    if (result != null && result['code'] == 200) {
                                      util.showToast('登录成功');
                                      util.setStorage('token', result['msg']);
                                      Navigator.pushNamedAndRemoveUntil(context, "/bookList", (route) => route == null);
                                    }else{
                                      util.setStorage('token', null);
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ])))));
  }
}
