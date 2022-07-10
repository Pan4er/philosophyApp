// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MainInfo extends StatelessWidget {
  String longDesc;
  String shortDesc;
  String imgUrl;
  MainInfo(this.longDesc, this.shortDesc, this.imgUrl, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(12, 25, 69, 1),
      appBar: AppBar(
        title: Text(shortDesc),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            height: 400.0,
            padding: EdgeInsets.only(bottom: 24),
            child: Ink.image(
              image: NetworkImage(imgUrl),
              fit: BoxFit.fill,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Text(
              longDesc,
              textAlign: TextAlign.left,
              style:
                  TextStyle(letterSpacing: 0.2, wordSpacing: 0.5, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
