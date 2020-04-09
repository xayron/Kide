import 'package:Kide/pages/AdminPanel/event/default_events.dart';
import 'package:Kide/pages/AdminPanel/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 220.0,
            child: DrawerHeader(
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Container()
                  ),
                  Positioned(
                    left: 5.0,
                    child: Text('KIDE'),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Entypo.login),
            title: Text('Admin'),
            onTap: () async {
              Navigator.pop(context);
              WidgetsFlutterBinding.ensureInitialized();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var rememberMe = prefs.getBool('rememberMe');
              Navigator.push(context, MaterialPageRoute(builder: (context)=> rememberMe == null || rememberMe == false ? LoginPage() : DefaultEvents()));
            },
          ),          
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}