import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:gardeneous/review.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'garden.dart';
import 'package:gardeneous/user.dart';

class ReviewScreen extends StatefulWidget {
  final User user;
  final Review review;
  final Garden garden;

  const ReviewScreen({Key key, this.user, this.review, this.garden})
      : super(key: key);
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double screenWidth, screenHeight;
  final TextEditingController _reviewcontroller = TextEditingController();
  final TextEditingController _ratingcontroller = TextEditingController();
  String _review = "";
  List reviewList;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green,
          title: Text(
            widget.garden.name,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: Container(
            child: Padding(
                padding: EdgeInsets.all(40.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          height: screenHeight / 3.5,
                          width: screenWidth / 1.5,
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://sopmy520.com/Gardeneous/images/gardenimages/${widget.garden.image}.jpg",
                            fit: BoxFit.fill,
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) => new Icon(
                              Icons.broken_image,
                              size: screenWidth / 2,
                            ),
                          )),
                      TextField(
                          controller: _reviewcontroller,
                          keyboardType: TextInputType.name,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                          decoration: InputDecoration(
                              labelText: 'Please enter your review',
                              icon: Icon(Icons.comment))),
                      SizedBox(height: 5),
                      TextField(
                          controller: _ratingcontroller,
                          keyboardType: TextInputType.name,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                          decoration: InputDecoration(
                              labelText: 'Rating', icon: Icon(Icons.star))),
                      SizedBox(height: 20),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 300,
                        height: 50,
                        child: Text('Add Review',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        color: Colors.green,
                        textColor: Colors.white,
                        elevation: 15,
                        onPressed: _onReviewDialog,
                      ),
                    ],
                  ),
                ))));
  }

  void _onReviewDialog() {
    _review = _reviewcontroller.text;
    if (_review == "") {
      Toast.show(
        "Please fill your review",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Finish Write " + widget.garden.name + " Review ?",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are You Sure ?",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _addReview();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.green,
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

  void _addReview() {
    http.post("https://sopmy520.com/Gardeneous/php/add_comment.php", body: {
      "plantname": widget.garden.name,
      "plantid": widget.garden.id,
      "plantimage": widget.garden.image,
      "email": widget.user.email,
      "name": widget.user.name,
      "review": _reviewcontroller.text,
      "rating": _ratingcontroller.text,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        Navigator.pop(context);
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
