import 'package:Kide/models/Event.dart';
import 'package:Kide/models/EventCategory.dart';
import 'package:Kide/pages/AdminPanel/event/categories.dart';
import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  Events({this.event, this.edit = false});
  final Event event;
  final bool edit;
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  
  int i, index;
  String name, theme, startDate, endDate;
  DateTime sDate = DateTime.now();
  DateTime eDate = DateTime.now();
  String dropDownValue = 'Add Event Categories';
  List<String> categoryList = ['...', 'Add Event Categories'];
  List<EventCategory> listCategory = [];
  TextEditingController tname = new TextEditingController();
  TextEditingController ttheme = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  dropDown(String value) async {
    if(value == 'Add Event Categories') {
      var result = await Navigator.push(context, 
          MaterialPageRoute(builder: (context) => Categories()));
      result != null ? setState((){
        if (categoryList[0] == '...'){
          categoryList.removeAt(0);
        }
        categoryList.insert(0, result.name);
        listCategory.insert(0, result);
      }) : NullThrownError();
    } else if (value != '...') {
      for(int i=0; i<listCategory.length; i++) {
        if(listCategory[i].name == value) {
          index = i;
          break;
        }
      }
    var result = await Navigator.push(context, 
      MaterialPageRoute(builder: (context) => 
        Categories(eventCategory: listCategory[index], edit: true)));
    if(result == 'Delete') {
      if(categoryList.length == 2) {
          categoryList.insert(0, '...');
          categoryList.removeAt(index+1);
          listCategory.removeAt(index);
        } else {
          categoryList.removeAt(index);
          listCategory.removeAt(index);
        }
        setState(() {
          dropDownValue = 'Add Event Categories';
        });
        return;
      }
      result != null ? setState(() {
        dropDownValue = result.name;
        categoryList[index] = result.name;
        listCategory[index] = result;
      }) : NullThrownError();
    }
    //TODO: Address error on having same element in the list
  }

  Future<Null> _selectDate(BuildContext context, int n)async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: n == 1 ? sDate : eDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2050));
    if (picked != null && picked != DateTime.now()) {     
      setState(() {
        if(n == 1) {
          sDate = picked;
          startDate = sDate.toLocal().toString().split(' ')[0];
        } else {
          print(sDate.compareTo(picked));
          if (sDate.compareTo(picked) == -1) {
            eDate = picked;
            endDate = eDate.toLocal().toString().split(' ')[0];
          } else {
             _scaffoldKey.currentState.showSnackBar(SnackBar(content: 
                Text('End date cannot be the same or less than start date')));
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    startDate = sDate.toLocal().toString().split(' ')[0];
    endDate = eDate.toLocal().toString().split(' ')[0];
    if(widget.edit) {
      startDate = widget.event.startDate;
      endDate = widget.event.endDate;
      tname.text = name = widget.event.name;
      // ttheme.text = theme = widget.event.theme;
      startDate = widget.event.startDate;
      endDate = widget.event.endDate;
      if(widget.event.eventCategories.isNotEmpty) {
        listCategory = widget.event.eventCategories;
        categoryList = [];
        for(i=0; i<listCategory.length; i++) {
          categoryList.add(listCategory[i].name);
        }
        categoryList.insert(i, 'Add Event Categories');
        dropDownValue = categoryList[0];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Events'),
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:40.0),
                child: TextField(
                  controller: tname,
                  onChanged: (value) {
                    name = tname.text;
                  },                  
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Event Name",
                    border: InputBorder.none,
                    fillColor: Colors.grey[900],
                    filled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => _selectDate(context, 1),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("$startDate"),
                              Icon(Icons.arrow_drop_down)
                            ],
                          ),
                        ),
                        height: 50,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                      ),
                    ),
                    Text('To'),
                    GestureDetector(
                      onTap: () => _selectDate(context, 2),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("$endDate"),
                              Icon(Icons.arrow_drop_down)
                            ],
                          ),
                        ),                      
                        height: 50,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                      ),
                    ),
                  ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:40.0),
                child: TextField(
                  controller: ttheme,
                  onChanged: (value) {
                    theme = ttheme.text;
                  },                  
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Theme",
                    fillColor: Colors.grey[900],
                    filled: true,
                    border: InputBorder.none,
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
                    height: 2,
                    color: Colors.grey,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropDownValue = newValue;
                    });
                    dropDown(newValue);
                  },
                  items: categoryList
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
                        if(widget.edit) {
                          Navigator.pop(context, 'Delete');
                        } else {
                           _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text('Nothing to Delete !')));
                        }
                      },
                      child: Text('Delete'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        if(name != null) {
                          Event event = new Event(id: null, name: name, startDate: startDate, 
                            endDate: endDate, /*theme: theme,*/ eventCategories: listCategory);
                          Navigator.pop(context, event);
                        } else {
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('Add Event Name first !')));
                        }
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}