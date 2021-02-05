import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gardeneous/addpost.dart';
import 'package:gardeneous/post.dart';
import 'package:gardeneous/post_detail.dart';
import 'package:gardeneous/user.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:like_button/like_button.dart';
//import 'package:toast/toast.dart';

class SharedPost extends StatefulWidget {
  final User user;

  const SharedPost({Key key, this.user}) : super(key: key);
  @override
  _SharedPostState createState() => _SharedPostState();
}

class _SharedPostState extends State<SharedPost> {
  List postList;
  List userList;
  bool liked = false;
  double screenWidth, screenHeight;
  String titlecenter = "Loading...";
  @override
  void initState() {
    super.initState();
    _loadPost();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Community Sharing Centre',
            style: TextStyle(fontSize: 17, color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                _addPost();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _loadPost();
              },
            ),
          ]),
      body: Column(
        children: [
          postList == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ))))
              : Flexible(
                  child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: (screenWidth / screenHeight) / 0.45,
                  children: List.generate(postList.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                            child: InkWell(
                                child: SingleChildScrollView(
                                    child: Column(
                          children: [
                            Container(
                                height: 150,
                                width: 150,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://sopmy520.com/Gardeneous/images/gardenimages/${postList[index]['image']}.jpg",
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) =>
                                      new CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      new Icon(
                                    Icons.broken_image,
                                    size: screenWidth / 2,
                                  ),
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Posted by : " + postList[index]['name'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      "Topic: " + postList[index]['topic'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                75, 0, 0, 0)),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        LikeButton(
                                          size: 25,
                                          likeCount: 0,
                                          likeBuilder: (bool like) {
                                            return Icon(Icons.favorite,
                                                color: like
                                                    ? Colors.red
                                                    : Colors.grey,
                                                size: 25);
                                          },
                                        ),
                                        SizedBox(width: 30),
                                        IconButton(
                                            icon: Icon(
                                              Icons.comment,
                                              color: Colors.green,
                                            ),
                                            onPressed: () {
                                              _loadPostDetail(index);
                                            }),
                                        SizedBox(width: 30),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete_outlined,
                                            color: Colors.green,
                                          ),
                                          onPressed: () =>
                                              _deletePostDetail(index),
                                        ),
                                      ],
                                    ),
                                  ]),
                            )
                          ],
                        )))));
                  }),
                ))
        ],
      ),
    );
  }

  void _loadPost() {
    http.post("https://sopmy520.com/Gardeneous/php/load_post.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "no data") {
        postList = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          postList = jsondata["post"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadPostDetail(int index) {
    Post post = new Post(
        id: postList[index]['id'],
        email: postList[index]['email'],
        name: postList[index]['name'],
        image: postList[index]['image'],
        topic: postList[index]['topic'],
        tips: postList[index]['tips']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PostDetail(post, widget.user)));
  }

  void _addPost() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AddPost(user: widget.user)));
  }

  void _loadUser() {
    print("Load User");

    http.post("http://sopmy520.com/Gardeneous/php/load_user.php",
        body: {}).then((res) {
      print("..." + res.body);

      if (res.body == "nodata") {
        userList = null;
        print("userList Null");
      } else {
        print("have data");
        setState(() {
          var jsondata = json.decode(res.body); //decode json data

          userList = jsondata["users"];

          print("userList get");
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deletePostDetail(int index) {
    print("Delete " + postList[index]['topic']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Delete posts",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure you want to delete " + postList[index]['topic'] + "?",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _deletePosts(index);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deletePosts(int index) {
    http.post("http://sopmy520.com/Gardeneous/php/delete_post.php", body: {
      "email": widget.user.email,
      "topic": postList[index]['topic'],
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        //Toast.show(
        //  "Delete Success",
        //  context,
        //  duration: Toast.LENGTH_LONG,
        //  gravity: Toast.TOP,
        // backgroundColor: Colors.black,
        // );
        _loadPost();
      } else {
        //Toast.show(
        ///  "Delete Failed",
        ///  context,
        //  duration: Toast.LENGTH_LONG,
        // gravity: Toast.TOP,
        //  backgroundColor: Colors.black,
        // );
      }
    }).catchError((err) {
      print(err);
    });
  }
}
