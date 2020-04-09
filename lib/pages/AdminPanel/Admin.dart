import 'package:Kide/pages/AdminPanel/event/default_events.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login/login.dart';

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var rememberMe = prefs.getBool('rememberMe');
    print(rememberMe);
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: rememberMe == null || rememberMe == false ? LoginPage() : DefaultEvents()
      )
    );
  }