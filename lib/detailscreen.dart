import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gardeneous/garden.dart';
import 'package:gardeneous/user.dart';

import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class GardenDetails extends StatefulWidget {
  final Garden garden;
  final User user;

  const GardenDetails({Key key, this.garden, this.user}) : super(key: key);
  @override
  _GardenDetailsState createState() => _GardenDetailsState();
}

class _GardenDetailsState extends State<GardenDetails> {
  final TextEditingController _remarkscontroller = TextEditingController();
  double screenWidth, screenHeight;
  int selectedQuantity;
  String _remarks = "";

  @override
  Widget build(BuildContext context) {
    var quantity =
        Iterable<int>.generate(int.parse(widget.garden.quantity) + 1).toList();
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
                padding: EdgeInsets.all(30.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          height: screenHeight / 3,
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
                      Row(
                        children: [
                          Icon(Icons.confirmation_number),
                          SizedBox(width: 20),
                          Container(
                            height: 50,
                            child: DropdownButton(
                              hint: Text(
                                'Quantity',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              value: selectedQuantity,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedQuantity = newValue;
                                  print(selectedQuantity);
                                });
                              },
                              items: quantity.map((selectedQuantity) {
                                return DropdownMenuItem(
                                  child: new Text(selectedQuantity.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  value: selectedQuantity,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      TextField(
                          controller: _remarkscontroller,
                          keyboardType: TextInputType.name,
                          maxLines: 3,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          decoration: InputDecoration(
                              labelText: 'Your Remark',
                              icon: Icon(Icons.notes))),
                      SizedBox(height: 20),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 300,
                        height: 50,
                        child: Text('Add to Cart',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        color: Colors.green,
                        textColor: Colors.black,
                        elevation: 15,
                        onPressed: _onOrderDialog,
                      ),
                    ],
                  ),
                ))));
  }

  void _onOrderDialog() {
    _remarks = _remarkscontroller.text;
    if (_remarks == "") {
      Toast.show(
        "Fill your remark",
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
            "Order " + widget.garden.name + "?",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Quantity: " + selectedQuantity.toString() + "?",
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
                _orderPlant();
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

  void _orderPlant() {
    http.post("https://sopmy520.com/Gardeneous/php/add_order.php", body: {
      "email": widget.user.email,
      "id": widget.garden.id,
      "quantity": selectedQuantity.toString(),
      "remarks": _remarkscontroller.text,
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
