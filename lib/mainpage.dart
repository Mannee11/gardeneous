import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gardeneous/addplant.dart';
import 'package:gardeneous/cartscreen.dart';
import 'package:gardeneous/detailscreen.dart';
import 'package:gardeneous/forumscreen.dart';
import 'package:gardeneous/loginscreen.dart';

import 'package:gardeneous/reviewscreen.dart';

import 'package:gardeneous/sharepage.dart';
import 'package:gardeneous/garden.dart';
import 'package:gardeneous/user.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:toast/toast.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List gardenList;
  List reviewList;
  double screenWidth, screenHeight;
  String titlecenter = "Loading Plant Type...";
  @override
  void initState() {
    super.initState();
    _loadGarden();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text('Main Screen',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.cloud_upload_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              _addPlantScreen();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              _loadGarden();
            },
          ),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text(widget.user.name,
                style: TextStyle(color: Colors.black)),
            accountEmail: new Text(widget.user.email,
                style: TextStyle(color: Colors.black)),
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Colors.white,
              child: new Text(
                widget.user.name.toString().substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.green,
            ),
            title: Text('Shopping Cart ', style: TextStyle(fontSize: 15)),
            onTap: () {
              _cartScreen();
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(
              Icons.star,
              color: Colors.green,
            ),
            title: Text('Review Station ', style: TextStyle(fontSize: 15)),
            onTap: () {
              _forumScreen();
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Colors.green,
            ),
            title: Text('Community Sharing Centre ',
                style: TextStyle(fontSize: 15)),
            onTap: () {
              _shareInfoScreen();
              // Update the state of the app.
              // ...
            },
          ),
          Expanded(child: SizedBox(height: 150)),
          Divider(),
          Container(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                leading: Icon(
                  Icons.power_settings_new,
                  color: Colors.green,
                ),
                title: Text('Logout', style: TextStyle(fontSize: 15)),
                onTap: () {
                  _signoutDialog();
                  // Update the state of the app.
                  // ...
                },
              ),
            ),
          ),
        ]),
      ),
      body: Column(
        children: [
          gardenList == null
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
                  crossAxisCount: 2,
                  childAspectRatio: (screenWidth / screenHeight) / 0.83,
                  children: List.generate(gardenList.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: new BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
                            child: InkWell(
                                onLongPress: () => _deletePlantList(index),
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Container(
                                        height: 110,
                                        width: 110,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://sopmy520.com/Gardeneous/images/gardenimages/${gardenList[index]['image']}.jpg",
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: 180.0,
                                            height: 100.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                const Radius.circular(10.0),
                                              ),
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              new CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              new Icon(
                                            Icons.broken_image,
                                            size: screenWidth / 20,
                                          ),
                                        )),
                                    Positioned(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(gardenList[index]['rating'],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              )),
                                          Icon(Icons.star, color: Colors.green),
                                        ],
                                      ),
                                      bottom: 50,
                                      right: 10,
                                    ),
                                    Text(
                                      gardenList[index]['name'],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      "RM: " + gardenList[index]['price'],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "QUANTITY: " +
                                          gardenList[index]['quantity'],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Container(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color: Colors.green)),
                                            color: Colors.green,
                                            onPressed: () {
                                              _loadReviewDetail(index);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(1),
                                              child: Text(
                                                "Review",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.shopping_cart_sharp,
                                              color: Colors.black,
                                            ),
                                            onPressed: () {
                                              _loadGardenDetail(index);
                                            },
                                          ),
                                        ]))
                                  ],
                                )))));
                  }),
                ))
        ],
      ),
    ));
  }

  void _loadGarden() {
    http.post("https://sopmy520.com/Gardeneous/php/load_garden.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "no data") {
        gardenList = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          gardenList = jsondata["garden"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadGardenDetail(int index) {
    print(gardenList[index]['name']);
    print('RM:' + gardenList[index]['price']);
    print('QUANTITY: ' + gardenList[index]['quantity']);
    Garden garden = new Garden(
        image: gardenList[index]['image'],
        id: gardenList[index]['id'],
        name: gardenList[index]['name'],
        price: gardenList[index]['price'],
        quantity: gardenList[index]['quantity']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                GardenDetails(garden: garden, user: widget.user)));
  }

  void _cartScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CartScreen(user: widget.user)));
  }

  void _addPlantScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                AddPlantScreen(user: widget.user)));
  }

  void _shareInfoScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => SharedPost(
                  user: widget.user,
                )));
  }

  void _loadReviewDetail(int index) {
    print(gardenList[index]['name']);
    Garden garden = new Garden(
        image: gardenList[index]['image'],
        id: gardenList[index]['id'],
        name: gardenList[index]['name']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ReviewScreen(garden: garden, user: widget.user)));
  }

  _deletePlantList(int index) {
    print("Delete " + gardenList[index]['name']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Delete plants",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure you want to delete " +
                gardenList[index]['name'] +
                "?",
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
                _deletePlants(index);
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

  void _deletePlants(int index) {
    http.post("http://sopmy520.com/Gardeneous/php/delete_plant.php", body: {
      "email": widget.user.email,
      "id": gardenList[index]['id'],
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Delete Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
          backgroundColor: Colors.black,
        );
        _loadGarden();
      } else {
        Toast.show(
          "Delete Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
          backgroundColor: Colors.black,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  _forumScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ForumScreen(user: widget.user)));
  }

  void _signoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Are You Sure You Want To Logout",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _signout();
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

  void _signout() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }
}
