import 'package:Kide/models/Event.dart';
import 'package:Kide/pages/AdminPanel/event/events.dart';
import 'package:Kide/pages/AdminPanel/login/login.dart';
import 'package:Kide/pages/AdminPanel/views/view_event.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefaultEvents extends StatefulWidget {
  @override
  _DefaultEventsState createState() => _DefaultEventsState();
}

class _DefaultEventsState extends State<DefaultEvents> {
  int i, index;
  String dropDownValue = 'Add Event';
  List<String> eventList = ['...', 'Add Event'];
  List<Event> events = [];

  dropDown(String value) async {
    if(value == 'Add Event') {
      var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => Events()));
      result != null ? setState(() {
        if(eventList[0] == '...') {
          eventList.removeAt(0);
        }
        events.insert(0, result);
        eventList.insert(0, result.name);
      }) : NullThrownError();
    } else if (value != '...') {
      for(i=0; i<events.length; i++) {
        if(events[i].name == value) {
          index = i;
          break;
        }
      }
      var result = await Navigator.push(context, MaterialPageRoute(builder: 
          (context) => Events(event: events[index], edit: true)));
            if(result == 'Delete') {
      if(eventList.length == 2) {
          eventList.insert(0, '...');
          eventList.removeAt(index+1);
          events.removeAt(index);
        } else {
          eventList.removeAt(index);
          events.removeAt(index);
        }
        setState(() {
          dropDownValue = 'Add Event';
        });
        return;
      }
      result != null ? setState(() {
        dropDownValue = result.name;
        eventList[index] = result.name;
        events[index] = result;
      }) : NullThrownError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Admin Panel'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Entypo.log_out), 
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('rememberMe', false);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
              }
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Events: '),
                SizedBox(height: 10.0),
                Container(
                  height: 300.0,
                  width: 350.0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20.0),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: events.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ExpandablePanel(
                          iconColor: Colors.white,
                          header: Text(events[index].name),
                          expanded: GestureDetector(
                            onTap: () => Navigator.push(context, 
                                  MaterialPageRoute(builder: (context) => ViewEventPage(event: events[index]))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // events[index].theme != null ? Text('Theme: ' + events[index].theme) : Container(),
                                // SizedBox(height: 10.0),
                                events[index].startDate != null ? Text('Start Date: ' + events[index].startDate) : Container(),
                                SizedBox(height: 10.0),
                                events[index].endDate != null ? Text('End Date: ' +events[index].endDate) : Container(),
                                SizedBox(height: 10.0),
                              ],
                            ),
                          ),
                        );
                      }, 
                      separatorBuilder: (BuildContext context, int index) => const Divider(height: 20.0,thickness: 2.0,),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
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
                    items: eventList
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(child: Text(value)),
                        );
                      })
                      .toList(),
                  ),
                ),
                // Center(
                //   child: RaisedButton(
                //     onPressed: () {},
                //     child: Text('New'),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}