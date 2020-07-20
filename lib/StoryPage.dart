import "package:flutter/material.dart";
import 'helpers/Constants.dart';
import "widgets/StoryWidget.dart";

class StoryPage extends StatelessWidget {
  final String slug;
  const StoryPage({Key key, this.slug}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: themeColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () => doSearch(),
          )
        ],
      ),
      body: new StoryWidget(slug: this.slug),
    );
  }

  doSearch() {
    return null;
  }
}