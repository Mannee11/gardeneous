import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'user.dart';
import 'package:intl/intl.dart';

class ForumScreen extends StatefulWidget {
  final User user;

  const ForumScreen({Key key, this.user}) : super(key: key);

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  List reviewlist;

  String titlecenter = "Loading Review ...";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadReview();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Review Station',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _loadReview();
              },
            ),
          ]),
      body: Column(
        children: [
          reviewlist == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ))))
              : Flexible(
                  child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: (screenWidth / screenHeight) / 0.20,
                  children: List.generate(reviewlist.length, (index) {
                    return Padding(
                        padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                        child: Card(
                            child: InkWell(
                                // onTap: () => _loadCoffeeDetails(index),
                                child: SingleChildScrollView(
                                    child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 110,
                              width: 110,
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://sopmy520.com/Gardeneous/images/gardenimages/${reviewlist[index]['plantimage']}.jpg",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 180.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Plant name  : " +
                                      reviewlist[index]['plantname'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  "User : " + reviewlist[index]['name'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  "Review : " + reviewlist[index]['review'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  "Rating : " + reviewlist[index]['rating'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            )
                          ],
                        )))));
                  }),
                ))
        ],
      ),
    ));
  }

  void _loadReview() {
    http.post("http://sopmy520.com/Gardeneous/php/load_comment.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "no data") {
        reviewlist = null;
        setState(() {
          titlecenter = "No Review Found";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          reviewlist = jsondata["review"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
