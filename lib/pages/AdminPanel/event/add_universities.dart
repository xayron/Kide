import 'package:flutter/material.dart';

class AddUniversititesPage extends StatefulWidget {
  AddUniversititesPage({this.uni, this.edit = false});
  final String uni;
  final bool edit;
  @override
  _AddUniversititesPageState createState() => _AddUniversititesPageState();
}

enum Department {treasury, state}

class _AddUniversititesPageState extends State<AddUniversititesPage> {
  String university;
  TextEditingController tuniversity = new TextEditingController();

  @override
  void initState(){
    super.initState();
    if(widget.edit == true) {
      tuniversity.text = widget.uni;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Universities'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: tuniversity,
            onChanged: (value) {
              university = tuniversity.text;
            },
          ),
          RaisedButton(
            onPressed: () => Navigator.pop(context, university),
            child: Text('Add'),
          ),
          RaisedButton(
            child: Text('Dialog'),
            onPressed: () {
              _askedToLead();
              // showDialog(
              //   context: context,
              //   builder: (_) => FunkyOverlay(),
              // );
            },
          )
        ],
      ),
    );
  }

  Future<void> _askedToLead() async {
    switch (await showDialog<Department>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select University'),
          content: TextField(
            controller: tuniversity,
            onChanged: (value) {
              university = tuniversity.text;
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "University",
              fillColor: Colors.grey[900],
              // filled: true,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Delete'),
            ),
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Add'),
            ),            
          ],
        );
      }
    )) {
      case Department.treasury:
        // Let's go.
        // ...
      break;
      case Department.state:
        // ...
      break;
    }
  }

}