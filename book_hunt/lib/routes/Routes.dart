import 'package:flutter/material.dart';
import 'package:book_hunt/pages/BookList.dart';
import 'package:book_hunt/pages/BookPage.dart';

final routes = {
  '/': (context) => BookListPage(),
  '/book': (context, {arguments}) => BookPage(arguments: arguments),
};

RouteFactory onGenerateRoute = (RouteSettings settings) {
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(builder: (context) => pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route = MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
  return MaterialPageRoute(builder: (context) => pageContentBuilder(context));
};
