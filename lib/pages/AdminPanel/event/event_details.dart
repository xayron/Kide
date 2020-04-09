import 'package:Kide/models/EventDetail.dart';
import 'package:flutter/material.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({this.eventDetail, this.edit = false});
  final EventDetail eventDetail;
  final bool edit;
  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {

  String dropdownValue = 'One';
  String header, desc;
  TextEditingController theader = new TextEditingController();
  TextEditingController tdesc = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();
    if(widget.edit) {
      theader.text = header = widget.eventDetail.header;
      tdesc.text = desc = widget.eventDetail.desc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Event Details'),
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
                    controller: theader,
                    maxLines: 1,
                    onChanged: (value) {
                      header = theader.text;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Header",
                      fillColor: Colors.grey[900],
                      filled: true,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:40.0),
                child: Container(
                  height: 5 * 24.0,
                  child: TextField(
                    controller: tdesc,
                    maxLines: 5,
                    onChanged: (value) {
                      desc = tdesc.text;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Description",
                      fillColor: Colors.grey[900],
                      filled: true,
                    ),
                  ),
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
                          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Nothing to delete !')));
                        }
                      },
                      child: Text('Delete'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        if(header != null) {
                          EventDetail eventDetail = new EventDetail(header: header, desc: desc);
                          Navigator.pop(context, eventDetail);
                        } else {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Add Header first !')));
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
    );
  }
}