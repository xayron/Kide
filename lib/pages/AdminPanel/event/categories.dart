import 'package:Kide/models/EventCategory.dart';
import 'package:Kide/models/SubEvent.dart';
import 'package:Kide/pages/AdminPanel/event/sub_events.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  Categories({this.eventCategory, this.edit = false});
  final EventCategory eventCategory;
  final bool edit;
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  String dropDownValue = 'Add Sub Event';
  String name;
  int i, index;
  List<String> subEvents = ['...','Add Sub Event'];
  TextEditingController tname = new TextEditingController();
  var subEventList = <SubEvent>[];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if(widget.edit) {
      tname.text = name = widget.eventCategory.name;
      if(widget.eventCategory.subEvents.isNotEmpty) {
        subEvents = [];
        subEventList = widget.eventCategory.subEvents;
        for(i=0; i<subEventList.length; i++) {
          subEvents.add(widget.eventCategory.subEvents[i].name);
        }
        subEvents.add('Add Sub Event');
        dropDownValue = subEvents[0];
      }
    }
  }

  dropDown(String value) async {
    if(value == 'Add Sub Event') {
      var result = await Navigator.push(context, 
            MaterialPageRoute(builder: (context) => SubEvents()));
      result != null ? setState((){
        if (subEvents[0] == '...'){
          subEvents.removeAt(0);
        }
        subEvents.insert(0, result.name);
        subEventList.insert(0, result);
      }) : NullThrownError();
    } else if (value != '...') {
      for(int i=0; i<subEventList.length; i++) {
        if(subEventList[i].name == value) {
          index = i;
          break;
        }
      }
      var result = await Navigator.push(context, 
            MaterialPageRoute(builder: (context) => SubEvents(subEvent: subEventList[index], edit: true)));
      if(result == 'Delete') {
        if(subEvents.length == 2) {
          subEvents.insert(0, '...');
          subEvents.removeAt(index+1);
          subEventList.removeAt(index);
        } else {
          subEvents.removeAt(index);
          subEventList.removeAt(index);
        }
        setState(() {
          dropDownValue = 'Add Sub Event';
        });
        return;
      }
      result != null ? dropDownValue = result.name : NullThrownError();
      setState(() {
        subEventList[index] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Categories',
            style: TextStyle(
              color: Colors.white
            ),
          ),
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:40.0),
                child: Container(
                  child: TextField(
                    controller: tname,
                    maxLines: 1,
                    onChanged: (value) {
                      name = tname.text;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Category Name",
                      fillColor: Colors.grey[900],
                      filled: true,
                    ),
                  ),
                ),
              ),
              Center(
                child: DropdownButton<String>(
                  value: dropDownValue,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                    color: Colors.grey
                  ),
                  underline: Container(
                    color: Colors.transparent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropDownValue = newValue;
                    });
                    dropDown(newValue);
                  },
                  items: subEvents
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(child: Text(value)),
                      );
                    })
                    .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:45.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () { 
                        if(widget.edit == true) {
                          Navigator.pop(context, 'Delete');
                        } else {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Nothing to delete')));
                        }
                      },
                      child: Text('Delete'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        if(name != null) {
                          EventCategory eventCategory = new EventCategory(id: null, name: name, subEvents: subEventList);
                          Navigator.pop(context, eventCategory);
                        } else {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Add Category name !')));
                        }
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}