import 'package:Kide/pages/AdminPanel/constatnts.dart';
import 'package:Kide/pages/AdminPanel/event/default_events.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool rememberMe;
  final user = new TextEditingController();
  final pass = new TextEditingController();

  login() {
    print('called');
    if(userid == 'admin' && password == 'password') {
      _setRememberMe(rememberMe);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DefaultEvents()));
    } else {
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Wrong Username or Password !')));
    }
  }

  void initState() {
    super.initState();
    rememberMe = false;
  }

  _setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', value);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Login',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w300
            ),
          ),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              LoginWidget(user: user, pass: pass),
              SizedBox(height:10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Checkbox(
                          activeColor: Colors.blueAccent,
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value;
                              pass.text = password;
                              user.text = userid;
                            });
                          }
                        ),
                        Text('Remember Me'),
                      ],
                    ),
                    GestureDetector(
                      child: Text('Forgot Password ?'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60.0),
              RaisedButton(
                onPressed: () {
                  login();
                },
                child: Text('Login'),
              ),
              SizedBox(height: 50.0),
            ],
          ),
        ),
      ),    
    );
  }
}