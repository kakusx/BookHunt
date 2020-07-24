import 'package:flutter/material.dart';
import 'package:book_hunt/routes/Routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
        onGenerateRoute: onGenerateRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue,
            textTheme: TextTheme(
                body1: TextStyle(fontSize: 16)
            )
        ));
  }
}