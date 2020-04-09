import 'package:Kide/pages/AdminPanel/views/view_event.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class SubEventsExpandable extends StatelessWidget {
  const SubEventsExpandable({
    Key key,
    @required this.widget,
    @required this.j,
    @required this.k
  }) : super(key: key);

  final ViewEventPage widget;
  final int j, k;

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      controller: new ExpandableController(),
      iconColor: Colors.white,
      header: Text(widget.event.eventCategories[j].subEvents[k].name),
      expanded: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.event.eventCategories[j].subEvents[k].time != null ? 
              Text('Date: ' + widget.event.eventCategories[j].subEvents[k].date) : Container(),
            widget.event.eventCategories[j].subEvents[k].time != null ? 
              Text('Time:' + widget.event.eventCategories[j].subEvents[k].time) :  Container(),
            widget.event.eventCategories[j].subEvents[k].location != null ? 
              Text('Location: ' +widget.event.eventCategories[j].subEvents[k].location) :  Container(),
            widget.event.eventCategories[j].subEvents[k].description != null ? 
              Text('Description: ' + widget.event.eventCategories[j].subEvents[k].description) :  Container(),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.event.eventCategories[j].subEvents[k].details.length,
              itemBuilder: (context, l) {
                return ExpandablePanel(
                  controller: new ExpandableController(),
                  iconColor: Colors.white,
                  header: widget.event.eventCategories[j].subEvents[k].details[l].header != null ? 
                    Text(widget.event.eventCategories[j].subEvents[k].details[l].header + ':') : Container(),
                  expanded: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: widget.event.eventCategories[j].subEvents[k].details[l].desc != null ? 
                      Text(widget.event.eventCategories[j].subEvents[k].details[l].desc) : Container(),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}

//TODO: null problem with view 