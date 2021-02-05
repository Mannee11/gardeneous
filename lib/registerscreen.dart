import 'package:flutter/material.dart';
import 'package:gardeneous/loginscreen.dart';

import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();
  final TextEditingController _pwcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //final TextEditingController _rpwcontroller = TextEditingController();
  String _phone = "";
  String _name = "";
  String _email = "";
  String _pass = "";
  bool _passwordVisible = false;
  bool _rememberMe = false;
//  bool _autoValidate = false;
  bool _termCondition = false;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(primarySwatch: Colors.green),
        home: new Scaffold(
          body: new SingleChildScrollView(
            child: new Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/wallpaper.jpg'),
                      fit: BoxFit.cover)),
              padding: new EdgeInsets.all(15.0),
              child: new Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: registration(context),
              ),
            ),
          ),
        ));
  }

  Widget registration(BuildContext context) {
    return new Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text("Create An Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.green,
                      fontWeight: FontWeight.bold)),
            ),
            Image.asset(
              "assets/images/Logo1.png",
              scale: 1.8,
            ),
            Container(
              child: TextFormField(
                controller: _namecontroller,
                validator: validateName,
                onSaved: (String val1) {
                  _name = val1;
                },
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                      borderRadius:
                          BorderRadius.all(const Radius.circular(20.0))),
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              child: TextFormField(
                controller: _emailcontroller,
                validator: validateEmail,
                onSaved: (String val1) {
                  _email = val1;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                      borderRadius:
                          BorderRadius.all(const Radius.circular(20.0))),
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.mail),
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              child: TextFormField(
                controller: _phonecontroller,
                validator: validatePhone,
                onSaved: (String val1) {
                  _phone = val1;
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                      borderRadius:
                          BorderRadius.all(const Radius.circular(20.0))),
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              child: TextFormField(
                controller: _pwcontroller,
                validator: validatePassword,
                onSaved: (String val1) {
                  _pass = val1;
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                      borderRadius:
                          BorderRadius.all(const Radius.circular(20.0))),
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                obscureText: true,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _rememberMe,
                  onChanged: (bool value) {
                    _onChange(value);
                  },
                ),
                Text('Remember Me', style: TextStyle(fontSize: 16))
              ],
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _termCondition,
                  onChanged: (bool value) {
                    _onChange1(value);
                  },
                ),
                SizedBox(height: 5),
                GestureDetector(
                    onTap: _showEULA,
                    child: Text('I Agree to Terms & Condition',
                        style: TextStyle(fontSize: 16, color: Colors.black))),
              ],
            ),
            SizedBox(height: 10),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0)),
              minWidth: 150,
              height: 50,
              child: Text(
                'Register',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              color: Colors.green,
              textColor: Colors.black,
              elevation: 20,
              onPressed: _showMyDialog,
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: _onLogin,
                child:
                    Text('Already Register  ', style: TextStyle(fontSize: 16))),
          ],
        )),
      ),
    );
  }

  void _onChange1(bool value) {
    setState(() {
      _termCondition = value;
    });
  }

  void _onRegister() async {
    _name = _namecontroller.text;
    _email = _emailcontroller.text;
    _phone = _phonecontroller.text;
    _pass = _pwcontroller.text;

    if (_name.length == 0 ||
        _email.length == 0 ||
        _phone.length == 0 ||
        _pass.length == 0 ||
        _termCondition == false) {
      if (_termCondition == false) {
        Toast.show(
          "Please agree Terms & Condition",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
        );
      } else {
        Toast.show(
          "Some information is missed!",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
        );
      }
    } else {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration...");
      await pr.show();

      http.post("http://sopmy520.com/Gardeneous/php/PHPMailer/index.php",
          body: {
            "name": _name,
            "email": _email,
            "phone": _phone,
            "password": _pass,
          }).then((res) {
        print(res.body);
        if (res.body == "success") {
          Toast.show(
            "Registration success. An email has been sent to .$_email. Please check your email for OTP verification. Also check in your spam folder.",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP,
          );
          if (_rememberMe) {
            savepref();
          }
          _onLogin();
        } else {
          Toast.show(
            "Registration failed",
            context,
            duration: Toast.CENTER,
            gravity: Toast.TOP,
          );
        }
      }).catchError((err) {
        print(err);
      });
      await pr.hide();
    }
  }

  void _onLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void savepref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = _emailcontroller.text;
    _pass = _pwcontroller.text;
    await prefs.setString('email', _email);
    await prefs.setString('password', _pass);
    await prefs.setBool('rememberme', true);
  }

  void _onChange(bool value) {
    setState(() {
      _rememberMe = value;
    });
  }

  String validateName(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Name is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be word";
    }
    return null;
  }

  String validatePhone(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Phone Number is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Phone Number must be digits";
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return "Password is Required";
    }
    return null;
  }

  void _showEULA() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("End-User License Agreement (EULA) of Gardeneous",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          content: new Container(
            height: 500,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.0,
                          ),
                          text:
                              "     This End-User License Agreement is a legal agreement between you and Sopmy520. This EULA agreement governs your acquisition and use of our Gardeneous software (Software) directly from Sopmy520 or indirectly through a Sopmy520 authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the Gardeneous software. It provides a license to use the Gardeneous e software and contains warranty information and liability disclaimers. If you register for a free trial of the Gardenous software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the Gardeneous software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by Sopmy520 herewith regardless of whether other software is referred to or described herein. The terms also apply to any Sopmy520 updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for Gardeneous. Sopmy520 shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of Sopmy520. Sopmy520 reserves the right to grant licences to use the Software to third parties",
                        )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation '),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Would you like to register a new account ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                _onRegister();
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
