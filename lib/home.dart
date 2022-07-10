// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:randomposts/categoriesModel.dart';
import 'package:randomposts/mainInfo.dart';
import 'package:randomposts/randomPostModel.dart';
import 'restApi.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = ScrollController();
  var filterScrollController = ScrollController();
  int currentTarget = 2000;
  int currentLimit = 9;

  int currentCategorieId = -1;
  bool useFilter = false;
  String currentWordToSearch = "";
  Icon currentSearchIcon = Icon(Icons.search);
  Widget currentTextBar = Text("Я в своём познании настолько преисполнился");
  TextEditingController textController = TextEditingController();
  Future<RandomPosts> randomPosts;
  Future<CategorieList> categories;
  @override
  void initState() {
    randomPosts = RestApi()
        .getPostsByLimit(currentLimit, currentWordToSearch, currentCategorieId);
    categories = RestApi().getCategories();
    super.initState();
  }

  void jumpUp() {
    controller.animateTo(0,
        duration: Duration(seconds: 1), curve: Curves.easeIn);
  }

  Future<RandomPosts> refreshList() {
    setState(() {
      currentTarget = 2000;
      currentLimit = 9;
      currentWordToSearch = "";
      currentTextBar = Text("Я в своём познании настолько преисполнился");
      currentSearchIcon = Icon(Icons.search);
      randomPosts = RestApi().getPostsByLimit(
          currentLimit, currentWordToSearch, currentCategorieId);
    });
    return randomPosts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: currentTextBar,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (currentSearchIcon.icon == Icons.search) {
                  currentSearchIcon = Icon(Icons.cancel);
                  currentTextBar = TextField(
                    controller: textController,
                    onChanged: (value) {
                      setState(() {
                        currentWordToSearch = value;
                        currentTarget = 2000;
                        currentLimit = 9;
                        randomPosts = RestApi().getPostsByLimit(currentLimit,
                            currentWordToSearch, currentCategorieId);
                      });
                    },
                    onSubmitted: (value) {
                      setState(() {
                        currentWordToSearch = value;
                        currentTarget = 2000;
                        currentLimit = 9;
                        randomPosts = RestApi().getPostsByLimit(currentLimit,
                            currentWordToSearch, currentCategorieId);
                        jumpUp();
                      });
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.search),
                        hintText: "Поиск",
                        hintStyle: TextStyle(color: Colors.white38),
                        helperStyle: TextStyle(color: Colors.white38)),
                    textInputAction: TextInputAction.go,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  );
                } else {
                  setState(() {
                    currentSearchIcon = Icon(Icons.search);
                    currentTextBar =
                        Text("Я в своём познании настолько преисполнился");
                    currentWordToSearch = "";
                    currentTarget = 2000;
                    currentLimit = 9;
                    randomPosts = RestApi().getPostsByLimit(
                        currentLimit, currentWordToSearch, currentCategorieId);
                  });
                }
              });
            },
            icon: currentSearchIcon,
            tooltip: 'Поиск по тексту',
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if (!useFilter) useFilter = true;

                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => AlertDialog(
                          title: Text('Поиск по категориям'),
                          backgroundColor: Color.fromRGBO(12, 25, 69, 1),
                          content: FutureBuilder<CategorieList>(
                            future: categories,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  height: 200,
                                  width: 400,
                                  child: ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      itemCount:
                                          snapshot.data.categories.length,
                                      itemBuilder: (context, index) {
                                        var categorie =
                                            snapshot.data.categories[index];
                                        return ListTile(
                                            selected:
                                                index == currentCategorieId - 1,
                                            selectedTileColor: Colors.black38,
                                            onTap: () {
                                              setState(() {
                                                currentCategorieId = index + 1;
                                                randomPosts = RestApi()
                                                    .getPostsByLimit(
                                                        currentLimit,
                                                        currentWordToSearch,
                                                        currentCategorieId);
                                              });
                                              Navigator.pop(context);
                                            },
                                            leading: Text(
                                              categorie.categorieName,
                                            ));
                                      }),
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (currentCategorieId == -1) {
                                      useFilter = false;
                                    }
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text("Назад")),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    useFilter = false;
                                    currentCategorieId = -1;
                                    currentTarget = 2000;
                                    currentLimit = 9;
                                    currentWordToSearch = "";
                                    randomPosts = RestApi().getPostsByLimit(
                                        currentLimit,
                                        currentWordToSearch,
                                        currentCategorieId);
                                  });

                                  Navigator.pop(context);
                                },
                                child: Text("Убрать фильтр"))
                          ],
                        ));
              });
            },
            icon: Icon(Icons.filter_list_alt,
                color: !useFilter ? Colors.white : Colors.blue),
            tooltip: 'Фильтр',
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: jumpUp,
        child: Icon(Icons.arrow_upward_rounded),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Color.fromRGBO(21, 21, 43, 1)),
          child: Scrollbar(
              isAlwaysShown: false,
              controller: controller,
              child: FutureBuilder<RandomPosts>(
                future: randomPosts,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return NotificationListener(
                        onNotification: (t) {
                          if (t is ScrollEndNotification) {
                            if (controller.position.pixels >= currentTarget) {
                              setState(() {
                                currentTarget += currentTarget;
                                currentLimit += currentLimit;
                                randomPosts = RestApi().getPostsByLimit(
                                    currentLimit,
                                    currentWordToSearch,
                                    currentCategorieId);
                              });
                            }
                          }
                          return false;
                        },
                        child: RefreshIndicator(
                            onRefresh: refreshList,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    controller: controller,
                                    physics: BouncingScrollPhysics(),
                                    padding: EdgeInsets.all(16),
                                    itemCount: snapshot.data.postsList.length,
                                    itemBuilder: (context, index) {
                                      var post = snapshot.data.postsList[index];
                                      return Padding(
                                          padding: EdgeInsets.only(bottom: 36),
                                          child: buildCard(post.shortDesc,
                                              post.longDesc, post.imageUrl));
                                    }))));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ))),
    );
  }
}

Card buildCard(String shortDesc, String longDesc, String imgUrl) {
  var cardImage = NetworkImage(imgUrl);

  return Card(
      elevation: 12.0,
      child: Column(
        children: [
          ListTile(
            title: Text(
              shortDesc,
              style: TextStyle(
                  letterSpacing: 0.2,
                  wordSpacing: 0.5,
                  fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            height: 200.0,
            decoration: BoxDecoration(
                image: DecorationImage(image: cardImage, fit: BoxFit.cover)),
          ),
          Container(
            height: 100,
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              longDesc,
              style: TextStyle(
                letterSpacing: 0.1,
                wordSpacing: 0.2,
              ),
              overflow: TextOverflow.fade,
            ),
          ),
          ButtonBar(
            children: [
              Builder(builder: (BuildContext context) {
                return TextButton(
                  child: const Text('Подробнее'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                MainInfo(longDesc, shortDesc, imgUrl)));
                  },
                );
              })
            ],
          )
        ],
      ));
}
