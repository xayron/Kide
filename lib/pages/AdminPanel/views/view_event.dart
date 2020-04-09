import 'package:Kide/models/Event.dart';
import 'package:Kide/pages/AdminPanel/views/SubEventExpanded.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ViewEventPage extends StatefulWidget {
  ViewEventPage({@required this.event});
  final Event event;
  @override
  _ViewEventPageState createState() => _ViewEventPageState();
}

class _ViewEventPageState extends State<ViewEventPage> {

  ExpandableController second = new ExpandableController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("ListView")),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      widget.event.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0
                      ),
                    ),
                    SizedBox(height:20.0),
                    // widget.event.theme != null ? Text('Theme: ' + widget.event.theme) : Container(),
                    widget.event.startDate != null ? Text('Start Date: ' + widget.event.startDate) : Container(),
                    widget.event.endDate != null ? Text('End Date: ' + widget.event.endDate) : Container(),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.event.eventCategories.length,
                  itemBuilder: (_, j) { 
                    return ListTile(
                      title: ExpandablePanel(
                        iconColor: Colors.white,
                        header: Text(widget.event.eventCategories[j].name),
                        expanded: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.event.eventCategories[j].subEvents.length,
                              itemBuilder: (context, k) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SubEventsExpandable(widget: widget, j: j, k: k)
                                );
                              }
                            ),
                          ),
                        ),
                      )
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}