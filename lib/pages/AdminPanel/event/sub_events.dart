import 'package:Kide/models/EventDetail.dart';
import 'package:Kide/models/SubEvent.dart';
import 'package:Kide/pages/AdminPanel/event/add_universities.dart';
import 'package:Kide/pages/AdminPanel/event/event_details.dart';
import 'package:flutter/material.dart';

class SubEvents extends StatefulWidget {
  SubEvents({this.subEvent, this.edit = false});
  final SubEvent subEvent;
  final bool edit;
  @override
  _SubEventsState createState() => _SubEventsState();
}

class _SubEventsState extends State<SubEvents> {

  int index;
  DateTime pickedDate = DateTime.now();
  TimeOfDay pickedTime = TimeOfDay.now();
  String detailsDropDownValue = 'Add Event Details';
  String universitiesDropDownValue = 'Add Universities';
  List<String> universityList = ['...', 'Add Universities'];
  List<String> detailsList = ['...','Add Event Details'];
  String name, date, time, location, description;
  String university;
  TextEditingController tuniversity = new TextEditingController();
  TextEditingController tname = new TextEditingController();
  TextEditingController tlocation = new TextEditingController();
  TextEditingController tdescription = new TextEditingController();
  List<EventDetail> listDetails = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    int i;
    date = pickedDate.toLocal().toString().split(' ')[0];
    time = pickedTime.hour.toString() + ':' + pickedTime.minute.toString();
    if(widget.edit) {
      tname.text = name = widget.subEvent.name;
      tlocation.text = location = widget.subEvent.location;
      tdescription.text = description = widget.subEvent.description;
      time = widget.subEvent.time;
      date = widget.subEvent.date;
      universityList = widget.subEvent.universities;
      universityList.add('Add Universities');
      universitiesDropDownValue = universityList[0];
      if(widget.subEvent.details.isNotEmpty) {
        listDetails = widget.subEvent.details;
        detailsList = [];
        for(i=0; i<widget.subEvent.details.length; i++) {
            detailsList.add(widget.subEvent.details[i].header);
        }
        detailsList.add('Add Event Details');
        detailsDropDownValue = detailsList[0];
      }
    }
  }

  Future<Null> _selectDate(BuildContext context)async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        pickedDate = picked;
        date = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: pickedTime,);
    if (picked != null && picked != TimeOfDay.now()) {
      setState(() {
        pickedTime = picked;
        time = pickedTime.hour.toString() + ':' + pickedTime.minute.toString();
      });
    }
  }

  Future<void> universityDialog(bool editUni) async {
    if(editUni) {
      tuniversity.text = university = universityList[index];
    }
    showDialog<Department>(
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
              onPressed: () {
                if(universityList.length == 2) {
                  universityList.insert(0, '...');
                  universityList.removeAt(index+1);
                } else {
                  universityList.removeAt(index);
                }
                setState(() {
                  universitiesDropDownValue = 'Add Universities';
                });
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
            FlatButton(
              onPressed: () {
                if(!editUni) {
                  var result = university;
                  result != null ? setState((){
                    if (universityList[0] == '...'){
                      universityList.removeAt(0);
                    }
                  universityList.insert(0, result);
                }) : NullThrownError();
                }
                else {
                  var result = university;
                  result != null ? setState(() {
                    universitiesDropDownValue = result;
                    universityList[index] = result;
                  }) : NullThrownError();                  
                }
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),            
          ],
        );
      }
    );
  }

  universitiesDropDown(String value) async {
    if(value == 'Add Universities') {
      tuniversity.clear();
      universityDialog(false);
    } else if(value != '...') {
      for(int i=0; i<universityList.length; i++) {
        if(value == universityList[i]) {
          index = i;
          break;
        }
      }
      universityDialog(true);
    }
  }

  dropDown(String value) async {
    if(value == 'Add Event Details') {
      var result = await Navigator.push(context, 
            MaterialPageRoute(builder: (context) => EventDetailsPage()));
      result != null ? setState((){
        if (detailsList[0] == '...'){
          detailsList.removeAt(0);
        }
        detailsList.insert(0, result.header);
        listDetails.insert(0, result);
      }) : NullThrownError();
    } else if (value != '...') {
      for(int i=0; i<listDetails.length; i++) {
        if(listDetails[i].header == value) {
          index = i;
          break;
        }
      }
      var result = await Navigator.push(context, 
        MaterialPageRoute(builder: (context) => 
          EventDetailsPage(eventDetail: listDetails[index], edit: true)));
      if(result == 'Delete') {
        if(detailsList.length == 2) {
          detailsList.insert(0, '...');
          detailsList.removeAt(index+1);
          listDetails.removeAt(index);
        } else {
          detailsList.removeAt(index);
          listDetails.removeAt(index);
        }
        setState(() {
          detailsDropDownValue = 'Add Event Details';
        });
        return;
      }
      result != null ? setState(() {
        detailsDropDownValue = result.header;
        detailsList[index] = result.header;
        listDetails[index] = result;
      }) : NullThrownError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Sub Events'),
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        hintText: "Event Name",
                        fillColor: Colors.grey[900],
                        filled: true,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Date'),
                      Text('Time'),                     
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("$date"),
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
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _selectTime(context),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("$time"),
                                Icon(Icons.arrow_drop_down)
                              ],
                            ),
                          ),                      
                          height: 50,
                          width: 100,
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
                  child: Container(
                    child: TextField(
                      controller: tlocation,
                      maxLines: 1,
                      onChanged: (value) {
                        location = tlocation.text;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Location",
                        fillColor: Colors.grey[900],
                        filled: true,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Center(
                        child: DropdownButton<String>(
                          value: universitiesDropDownValue,
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
                              universitiesDropDownValue = newValue;
                            });
                            universitiesDropDown(newValue);
                          },
                          items: universityList.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(child: Text(value)),
                              );
                            })
                            .toList(),
                        ),
                      ),
                      Center(
                        child: DropdownButton<String>(
                          value: detailsDropDownValue,
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
                              detailsDropDownValue = newValue;
                            });
                            dropDown(newValue);
                          },
                          items: detailsList
                            .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(child: Text(value)),
                              );
                            })
                            .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:40.0),
                  child: Container(
                    height: 5 * 24.0,
                    child: TextField(
                      controller: tdescription,
                      onChanged: (value) {
                        description = tdescription.text;
                      },
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter event details",
                        fillColor: Colors.grey[900],
                        filled: true,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          if (widget.edit == true) {
                            Navigator.pop(context, 'Delete');
                          } else {
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text('Nothing to delete'))
                            );
                          }
                        },
                        child: Text('Delete'),
                      ),
                      RaisedButton(
                        onPressed: () {
                          if(name != null) {
                            universityList.removeLast();
                            var uniList = universityList;
                            SubEvent subEvent = new SubEvent(
                              name: name, date: date, description: description, time: time, 
                              location: location, universities: uniList, details: listDetails
                            );
                            Navigator.pop(context, subEvent);
                          } else {
                           _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text('Missing event name !'))
                            );
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
      ),
    );
  }
}