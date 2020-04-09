import 'package:flutter/material.dart';
import '../constatnts.dart';

bool passwordVisible = true;

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key key, @required this.user, @required this.pass}) : super(key: key);
  final TextEditingController user;
  final TextEditingController pass;
  
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50.0),
              CircleAvatar(
                radius: 60.0,
                child: Icon(
                  Icons.account_circle,
                  size: 110.0,
                ),
              ),
              SizedBox(height: 50.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:40.0),
                child: TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  controller: widget.user,
                  onChanged: (text) {
                    userid = widget.user.text;
                  },
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your Username',
                    fillColor: Colors.grey[900],
                    filled: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 40.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:40.0),
                child: TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  controller: widget.pass,
                  onChanged: (text) {
                    password = widget.pass.text;
                  },
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    fillColor: Colors.grey[900],
                    filled: true,
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}