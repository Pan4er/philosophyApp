// ignore_for_file: file_names, non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'randomPostModel.dart';
import 'categoriesModel.dart';
import 'dart:convert';

class RestApi {
  Future<RandomPosts> getPostsByLimit(
      var limit, String wordToSearch, int categorieId) async {
    var randomPosts = RandomPosts(postsList: [
      PostsList(
          id: 1,
          longDesc: "Ошибка",
          shortDesc: "Ошибка сервера",
          imageUrl:
              "https://walletinvestments.ru/wp-content/uploads/2019/02/mistake.jpg")
    ]);
    var client = http.Client();
    Uri url;

    if (categorieId == -1) {
      wordToSearch.isEmpty
          ? url = Uri.http("3.64.8.106:8080", "/posts/limit/$limit")
          : url =
              Uri.http("3.64.8.106:8080", "/posts/limit/$limit/$wordToSearch");
    } else {
      wordToSearch.isEmpty
          ? url = Uri.http(
              "3.64.8.106:8080", "/posts/categorie/$categorieId/$limit")
          : url = Uri.http(
              "3.64.8.106:8080", "/filter/$categorieId/$limit/$wordToSearch");
    }

    try {
      var response = await client.get(url);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        var randomPosts = RandomPosts.fromJson(jsonMap);
        client.close();
        return randomPosts;
      }
      // ignore: non_constant_identifier_names
    } catch (Exc) {
      client.close();
      return RandomPosts(postsList: [
        PostsList(
            id: 1,
            longDesc: "Ошибка",
            shortDesc: "Ошибка сервера",
            imageUrl:
                "https://walletinvestments.ru/wp-content/uploads/2019/02/mistake.jpg")
      ]);
    }
    client.close();
    return randomPosts;
  }

  Future<CategorieList> getCategories() async {
    var client = http.Client();
    var url = Uri.http("3.64.8.106:8080", "/categories");
    var categories = CategorieList(
        categories: [Categories(categorieName: "Error", id: -404)]);
    try {
      var response = await client.get(url);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        var categories = CategorieList.fromJson(jsonMap);
        client.close();
        return categories;
      }
    } catch (Exc) {
      client.close();
      return CategorieList(
          categories: [Categories(categorieName: "Error", id: -404)]);
    }
    client.close();
    return categories;
  }
}
