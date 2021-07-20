import 'package:flutter/material.dart';

class SearchBarDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        child: Card(
          color: Colors.redAccent,
          child: Text(query),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    const searchList = [
      "宇智波-斑",
      "宇智波-泉奈",
      "宇智波-鼬",
      "宇智波-=佐助",
      "千手-柱间",
      "千手-扉间",
    ];

    const recentSuggest = ["推荐-1", "推荐-2"];

    final suggestionList = query.isEmpty ? recentSuggest : searchList.where((input) => input.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionList.length == 0 ? 0 : suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        title: RichText(
          text: TextSpan(
              text: suggestionList[index].substring(0, query.length),
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [TextSpan(text: suggestionList[index].substring(query.length), style: TextStyle(color: Colors.grey))]),
        ),
      ),
    );
  }
}
