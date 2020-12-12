import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mainpage.dart';
import 'package:gardeneous/registerscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  String _email = "";
  final TextEditingController _pwcontroller = TextEditingController();
  String _pass = "";
  bool _rememberMe = false;
  SharedPreferences prefs;

  @override
  void initState() {
    loadpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.green,
              title: Text(
                'Sign in',
                style: TextStyle(fontSize: 20),
              ),
            ),
            body: Center(
                child: Container(
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/wallpaper.jpg'),
                            fit: BoxFit.cover)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: EdgeInsets.all(30),
                        child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "assets/images/Logo1.png",
                                  width: 190.0,
                                  height: 190.0,
                                ),
                                TextField(
                                  controller: _emailcontroller,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(20.0))),
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.mail),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: _pwcontroller,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(20.0))),
                                    labelText: 'Password',
                                    prefixIcon: Icon(Icons.lock),
                                  ),
                                  obscureText: true,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(40.0)),
                                  minWidth: 300,
                                  height: 50,
                                  child: Text(
                                    'Login',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  elevation: 10,
                                  onPressed: _onLogin,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: (bool value) {
                                        _onchanged(value);
                                      },
                                    ),
                                    Text('Remember Me',
                                        style: TextStyle(fontSize: 15))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Don't have an account? ",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black)),
                                    GestureDetector(
                                      onTap: _onRegister,
                                      child: Text('Sign up',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.redAccent)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                    )))));
  }

  void _onchanged(bool value) {
    setState(() {
      _rememberMe = value;
      saveprf(value);
    });
  }

  void _onRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    print('Backpress');
    return Future.value(false);
  }

  Future<void> _onLogin() async {
    _email = _emailcontroller.text;
    _pass = _pwcontroller.text;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Login...");
    await pr.show();
    http.post("https://sopmy520.com/Gardeneous/php/login_user.php/", body: {
      "email": _email,
      "password": _pass,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Login Sucess",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => MainPage()));
      } else {
        Toast.show(
          "Login Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  void loadpref() async {
    prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email')) ?? '';
    _pass = (prefs.getString('password')) ?? '';
    _rememberMe = (prefs.getBool('rememeberme')) ?? false;
    if (_email.isNotEmpty) {
      setState(() {
        _emailcontroller.text = _email;
        _pwcontroller.text = _pass;
        _rememberMe = _rememberMe;
      });
    }
  }

  void saveprf(bool value) async {
    prefs = await SharedPreferences.getInstance();
    _email = _emailcontroller.text;
    _pass = _pwcontroller.text;

    if (value) {
      if (_email.length < 3 && _pass.length < 3) {
        print('EMAIL/PASSWORD IS EMPTY');
        _rememberMe = false;
        Toast.show(
          "Email/Password is Empty",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        return;
      } else {
        await prefs.setString('email', _email);
        await prefs.setString('password', _pass);
        await prefs.setBool('rememberme', value);
        Toast.show(
          "Preferences saved",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        print('SUCCESS');
      }
    } else {
      await prefs.setString('email', "");
      await prefs.setString('password', "");
      await prefs.setBool('rememberme', false);
      setState(() {
        _emailcontroller.text = '';
        _pwcontroller.text = '';
        _rememberMe = false;
        Toast.show(
          "Preferences removed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
      });
    }
  }
}
