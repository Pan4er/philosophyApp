// To parse this JSON data, do
//
//     final randomPosts = randomPostsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class RandomPosts {
  List<PostsList> postsList;

  RandomPosts({this.postsList});

  RandomPosts.fromJson(Map<String, dynamic> json) {
    if (json['postsList'] != null) {
      postsList = <PostsList>[];
      json['postsList'].forEach((v) {
        postsList.add(new PostsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.postsList != null) {
      data['postsList'] = this.postsList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostsList {
  int id;
  String longDesc;
  String shortDesc;
  String imageUrl;

  PostsList({this.id, this.longDesc, this.shortDesc, this.imageUrl});

  PostsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    longDesc = json['longDesc'];
    shortDesc = json['shortDesc'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['longDesc'] = this.longDesc;
    data['shortDesc'] = this.shortDesc;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
