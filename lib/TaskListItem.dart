import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'TaskC.dart';
import 'dart:math' as math;
import 'TasksViewConfig.dart';

class TaskListItem extends StatefulWidget {
  final TaskC task;
  final DateTime maxDeadline;
  final TasksViewConfig config;
  TaskListItem(this.task, this.maxDeadline, this.config);

  @override
  TaskListItemState createState() => TaskListItemState();
}

class TaskListItemState extends State<TaskListItem> {
  bool checked = false;

  String remainTimeToString(int ms) {
    int seconds = ms ~/ (1000);
    int minutes = ms ~/ (1000 * 60);
    int hours = ms ~/ (1000 * 60 * 60);
    int days = ms ~/ (1000 * 60 * 60 * 24);
    int monthes = ms ~/ (1000 * 60 * 60 * 24 * 30);
    int years = ms ~/ (1000 * 60 * 60 * 24 * 30 * 12);

    double minutesD = ms / (1000 * 60);
    double hoursD = ms / (1000 * 60 * 60);
    double daysD = ms / (1000 * 60 * 60 * 24);
    double monthesD = ms / (1000 * 60 * 60 * 24 * 30);
    double yearsD = ms / (1000 * 60 * 60 * 24 * 30 * 12);

    if (years == 1) return "$years year";
    if (years > 0) return "${yearsD.toStringAsFixed(1)} years";
    if (monthes == 1) return "$monthes month";
    if (monthes > 0) return "${monthesD.toStringAsFixed(1)} months";
    if (days == 1) return "$days day";
    if (days > 0) return "${daysD.toStringAsFixed(1)} days";
    if (hours == 1) return "$hours hour";
    if (hours > 0) return "${hoursD.toStringAsFixed(1)} hours";
    if (minutes == 1) return "$minutes min";
    if (minutes > 0) return "${minutesD.toStringAsFixed(1)} mins";
    if (seconds == 1) return "$seconds sec";

    return "$seconds secs";
  }

  String finishDateToString(DateTime finishDate, int msToFinish) {
    DateFormat formatter = new DateFormat('dd.MM.yy');
    if (msToFinish < 1000 * 60 * 60 * 24) formatter = new DateFormat('jm');
    return formatter.format(finishDate);
  }

  @override
  Widget build(BuildContext buildContext) {
    DateTime nowTime = DateTime.now();
    int nowMs = nowTime.millisecondsSinceEpoch;
    int taskDeadlineMs = widget.task.deadline.millisecondsSinceEpoch;
    int maxDeadlineMs = widget.maxDeadline.millisecondsSinceEpoch;
    int diffMs = taskDeadlineMs - nowMs;
    double coeff = 1 - (taskDeadlineMs - nowMs) / (maxDeadlineMs - nowMs);
    coeff = math.pow(coeff, 8);

    return ListTile(
      title: new Text(widget.task.name),
      subtitle: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            width: MediaQuery.of(buildContext).size.width * coeff,
            decoration: new ShapeDecoration(
              shape: new Border.all(color: Colors.red, width: 2.0),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(remainTimeToString(diffMs)),
              new Text(finishDateToString(widget.task.deadline, diffMs)),
            ],
          )
        ],
      ),
      leading: new Checkbox(
        value: checked,
        onChanged: (val) {
          setState(() {
            checked = val;
          });
        },
      ),
    );
  }
}
