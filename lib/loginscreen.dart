import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardeneous/user.dart';
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
  bool autovalidate = false;
  bool _passwordShow = false;
  final TextEditingController _emailcontroller = TextEditingController();
  String _email = "";
  final TextEditingController _pwcontroller = TextEditingController();
  String _pass = "";

  final formKeyForResetEmail = GlobalKey<FormState>();
  final formKeyForResetPassword = GlobalKey<FormState>();

  TextEditingController emailForgotController = new TextEditingController();
  TextEditingController passResetController = new TextEditingController();
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
          resizeToAvoidBottomPadding: true,
          body: new Container(
            decoration: BoxDecoration(
              color: Colors.lightGreenAccent[100],
            ),
            padding: EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/Logo1.png",
                      width: 180,
                      height: 180,
                    ),
                    TextField(
                      controller: _emailcontroller,
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
                    SizedBox(
                      height: 7,
                    ),
                    TextField(
                      controller: _pwcontroller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                            borderRadius:
                                BorderRadius.all(const Radius.circular(20.0))),
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0)),
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
                      height: 7,
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (bool value) {
                            _onchanged(value);
                          },
                        ),
                        Text('Remember Me', style: TextStyle(fontSize: 15))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ",
                            style:
                                TextStyle(fontSize: 15, color: Colors.black)),
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
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _forgotPassword,
                          child: Text('Forgot Password',
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
        ));
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
      List userdata = res.body.split(",");
      if (userdata[0] == "success") {
        Toast.show(
          "Login Sucess",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        User user = new User(
            email: _email,
            name: userdata[1],
            password: _pass,
            phone: userdata[2],
            datereg: userdata[3]);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(user: user)));
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

  void _forgotPassword() {
    TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Forgot Password ?",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          content: new Container(
              height: 100,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Enter Your Email : ",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Form(
                        key: formKeyForResetEmail,
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email', icon: Icon(Icons.email)),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                          validator: emailValidate,
                          onSaved: (String value) {
                            _email = value;
                          },
                        )),
                  ],
                ),
              )),
          actions: <Widget>[
            new FlatButton(
                child: new Text(
                  "Yes, Reset Password",
                  style: TextStyle(
                      color: Colors.green[700], fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (formKeyForResetEmail.currentState.validate()) {
                    _passwordShow = false;
                    emailForgotController.text = emailController.text;
                    _enterResetPass();
                  }
                }),
            new FlatButton(
              child: new Text(
                "No, Return Login",
                style: TextStyle(
                    color: Colors.red[700], fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  String emailValidate(String value) {
    if (value.isEmpty) {
      return 'Email is Required';
    }

    if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value)) {
      return 'Please Enter a Valid Email Address!';
    }
    return null;
  }

  void _enterResetPass() {
    TextEditingController passController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: new Text(
                "New Password",
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              content: new Container(
                  height: 100,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Enter Your New Password : ",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                        Form(
                            key: formKeyForResetPassword,
                            child: TextFormField(
                                controller: passController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  icon: Icon(Icons.lock),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _passwordShow = !_passwordShow;
                                      });
                                    },
                                    child: Icon(_passwordShow
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                                obscureText: !_passwordShow,
                                validator: passValidate,
                                onSaved: (String value) {
                                  _pass = value;
                                }))
                      ],
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes, Done",
                      style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (formKeyForResetPassword.currentState.validate()) {
                        passResetController.text = passController.text;
                        _resetPass();
                      }
                    }),
                new FlatButton(
                  child: new Text(
                    "No, Cancel",
                    style: TextStyle(
                        color: Colors.red[700], fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  String passValidate(String value) {
    if (value.isEmpty) {
      return 'Password is Required';
    }

    if (value.length < 5) {
      return 'Password Length Must Be 5 Digits Above';
    }
    return null;
  }

  void _resetPass() {
    String email = emailForgotController.text;
    String password = passResetController.text;

    final form = formKeyForResetPassword.currentState;

    if (form.validate()) {
      form.save();
      http.post("https://sopmy520.com/Gardeneous/php/reset_password.php",
          body: {
            "email": email,
            "password": password,
          }).then((res) {
        print(res.body);
        if (res.body.contains("success")) {
          Navigator.of(context).pop();
          Toast.show("Reset Password Success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        } else {
          Toast.show("Reset Password Failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      setState(() {
        // autoValidate = true;
      });
    }
  }
}
