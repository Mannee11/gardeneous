import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gardeneous/post.dart';
import 'package:gardeneous/user.dart';
import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';

import 'package:toast/toast.dart';

//import 'package:keyboard_visibility/keyboard_visibility.dart';

class PostDetail extends StatefulWidget {
  final Post postsss;
  final User usersss;

  PostDetail(this.postsss, this.usersss);
  @override
  _PostDetailState createState() => _PostDetailState(postsss, usersss);
}

class _PostDetailState extends State<PostDetail> {
  Post posts;
  User users;
  _PostDetailState(Post postsss, User usersss);
  List postList;
  List commentList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading post...";
  final TextEditingController _commentcontroller = TextEditingController();
  String _commentcaption = "";

  // KeyboardVisibilityNotification _keyboardVisibility =
  //    new KeyboardVisibilityNotification();
  //int _keyboardVisibilitySubscriberId;
  // bool _keyboardState;

  @override
  void initState() {
    super.initState();
    posts = widget.postsss;
    users = widget.usersss;
    _loadDetails();

    // _keyboardState = _keyboardVisibility.isKeyboardVisible;
    //  print(_keyboardState);

    /*_keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardState = visible;
          print(_keyboardState);
        });
      },
    );*/

    _loadComments();
    //_loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(posts.topic),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  _loadComments();
                },
              ),
            ]),
        body: Column(children: [
          Container(
              padding: EdgeInsets.all(3),
              child: (Column(
                children: [
                  Container(
                      //padding: EdgeInsets.all(20),
                      child: Column(
                    children: [
                      Container(
                          child: Column(children: [
                        Container(
                            height: 300,
                            width: 300,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://sopmy520.com/Gardeneous/images/gardenimages/${posts.image}.jpg",
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  new CircularProgressIndicator(),
                              errorWidget: (context, url, error) => new Icon(
                                Icons.broken_image,
                                size: screenWidth / 2,
                              ),
                            )),
                        SizedBox(height: 5),
                        LikeButton(),
                        Row(children: [
                          Text("Topic  :  " + posts.topic,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ]),

                        //Text(DateFormat('yyyy-MM-dd hh:mm aaa').format(postList[index]['postdate'])),
                        Column(children: <Widget>[
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text("Tips  :  " + posts.tips,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ))
                        ]),
                      ])),
                    ],
                  )),
                ],
              ))),
          Expanded(
            child: SingleChildScrollView(
              child: commentList == null
                  ? Container(
                      child: Container(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text("No Comment"),
                          )))
                  : Container(
                      child: Container(
                          padding: EdgeInsets.all(20),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: commentList.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                // print(commentList.length);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(commentList[index]['username'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green)),
                                        Text(" (" +
                                            commentList[index]['datecomment'] +
                                            " )"),
                                      ],
                                    ),
                                    Text(commentList[index]['caption'],
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                );
                              }))),
            ),
          ),
          TextField(
              controller: _commentcontroller,
              decoration: InputDecoration(
                  labelText: "Comment",
                  icon: new Icon(Icons.comment_outlined),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _updatenewcomment();
                    },
                    icon: Icon(Icons.send),
                  ))),
        ]));
  }

  void _loadDetails() {
    print("Load post");
    http.post("https://sopmy520.com/Gardeneous/php/load_post.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        postList = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body); //decode json data

          postList = jsondata["post"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadComments() {
    http.post("http://sopmy520.com/Gardeneous/php/load_newcomments.php", body: {
      "topic": widget
          .postsss.topic, //send the postid to load_comments.php to get data
    }).then((res) {
      print(res.body);

      if (res.body == "nodata") {
        print("commentList is null");
        commentList = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body); //decode json data

          commentList = jsondata["comments"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _updatenewcomment() {
    final dateTime = DateTime.now();
    _commentcaption = _commentcontroller.text;

    http.post("http://sopmy520.com/Gardeneous/php/add_newComment.php", body: {
      "topic": posts.topic,
      "caption": _commentcaption,
      "useremail": users.email,
      "username": users.name,
      "datecomment": "-${dateTime.microsecondsSinceEpoch}",
    }).then((res) {
      print(res.body);

      if (res.body == "success") {
        Toast.show(
          "Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      } else {
        Toast.show(
          "Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }
}
