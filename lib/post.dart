import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_anis/post_details_page.dart';
import 'package:project_anis/posts_request_page.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:math' as math;

// ignore: must_be_immutable
class MyPostPage extends StatefulWidget {
  var channel;

  @override
  _MyPostPageState createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  List posts = [];
  String imageText = '';
  String titleText = '';
  String descriptionText = '';
  String dateText = '';
  String authorText = '';
  String image = '';
  String textId = '';
  dynamic decodedResults;

  int? _selectedIndex;
  _onSelected(int index) {
    //https://inducesmile.com/google-flutter/how-to-change-the-background-color-of-selected-listview-in-flutter/
    setState(() {
      _selectedIndex = index;
    });
  }

  var index;
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://besquare-demo.herokuapp.com'),
  );

  //late IO.Socket socket;
  @override
  initState() {
    super.initState();
    //getting all posts response:
    channel.sink.add('{"type": "sign_in","data": {"name": "anis"}}');
    channel.stream.listen((results) {
      final decodedResults = jsonDecode(results);
      if (decodedResults['type'] == 'all_posts') {
        posts = decodedResults['data']['posts'];
      }
      setState(() {});
    });
    _getPosts();
  }

//getting all posts request:
  void _getPosts() {
    channel.sink.add('{"type":"get_posts","data":{"limit": " "}}');
  }

  //boolean for checking the sorting method by alphabet:
  bool isClicked = false;
  bool sortisClicked = false;

  @override
  Widget build(BuildContext context) {
    //to display the latest post:
    var reverseList = posts.reversed.toList();

    return Scaffold(
        backgroundColor: Colors.purple[900],
        appBar: AppBar(
            title: const Center(
              child: Text('Welcome to PostPage'),
            ),
            leading: GestureDetector(
              onTap: () {},
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostRequestPage()));
                },
                icon: Icon(
                  Icons.add,
                ),
                color: Colors.black,
                iconSize: 30.0,
              ),
            ),
            //sorting method:
            actions: sortisClicked == false
                ? <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              posts = reverseList.toList();
                              sortisClicked = true;
                            });
                          },
                          icon: Icon(
                            Icons.sort_by_alpha,
                          ),
                          color: Colors.white,
                          iconSize: 30.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.favorite,
                          ),
                          color: Colors.red,
                          iconSize: 30.0,
                        ),
                      ),
                    )
                  ]
                : <Widget>[
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                          icon: const Icon(Icons.sort_by_alpha),
                          onPressed: () {
                            setState(() {
                              posts = reverseList.toList();
                              sortisClicked = false;
                            });
                          },
                        ),
                      ),
                    )
                  ]),
        body: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 5,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.limeAccent,
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: (
                              {imageText = 'image',
                              titleText = 'title',
                              descriptionText = 'description',
                              dateText = 'date',
                              authorText = 'author'}) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostDetailsPage(
                                        getImageUrl: posts[index]['image'],
                                        getTitle: posts[index]['title'],
                                        getDesc: posts[index]['description'])));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                child: Image.network(
                                  posts[index]["image"],
                                  errorBuilder: (_1, _2, _3) {
                                    return SizedBox.shrink();
                                  },
                                  fit: BoxFit.fill,
                                ),
                                //fit: BoxFit.fill,),
                              ),
                              Expanded(
                                  child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Display title:
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 8),
                                      child: Text(
                                        posts[index]["title"],
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),

                                    //Display date:
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 8),
                                      child: Text(
                                        posts[index]["date"],
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontStyle: FontStyle.italic),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    //Display author:
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 8),
                                      child: Text(
                                        posts[index]["author"],
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontStyle: FontStyle.italic),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              Expanded(
                                  child: Container(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          textId = posts[index]["_id"];
                                          print(textId);
                                          channel.sink.add(
                                              '{"type": "delete_post","data": {"postId": "$textId"}}');
                                        },
                                        icon: const Icon(Icons.delete_sharp)),
                                    IconButton(
                                        icon: Icon(
                                          Icons.favorite,
                                          color: _selectedIndex != null &&
                                                  _selectedIndex == index
                                              ? Colors.redAccent
                                              : Colors.grey,
                                        ),
                                        onPressed: () {
                                          _onSelected(index);
                                        }
                                        /*icon: const Icon(Icons.favorite)*/),
                                  ],
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }));
  }

  void navigateToPostDetailsPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PostDetailsPage(
          getTitle: posts[index]['title'],
          getDesc: posts[index]['description'],
          getImageUrl: posts[index]['image']);
    }));
  }
}

// ignore: camel_case_types
//class _getPosts {}
