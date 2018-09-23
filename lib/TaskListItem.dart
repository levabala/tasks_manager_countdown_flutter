import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'TaskC.dart';
import 'dart:math' as math;
import 'TasksViewConfig.dart';

class TaskListItem extends StatefulWidget {
  final TaskC task;
  final DateTime maxDeadline;
  final DateTime minDeadline;
  final TasksViewConfig viewConfig;
  TaskListItem({
    this.task,
    this.maxDeadline,
    this.minDeadline,
    this.viewConfig,
  });

  @override
  TaskListItemState createState() => TaskListItemState();
}

class TaskListItemState extends State<TaskListItem> {
  bool checked = false;

  String remainTimeToString(int ms) {
    bool happened = ms <= 0;
    ms = ms.abs();

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

    String str = "$seconds secs";
    if (years == 1)
      str = "$years year";
    else if (years > 0)
      str = "${yearsD.toStringAsFixed(1)} years";
    else if (monthes == 1)
      str = "$monthes month";
    else if (monthes > 0)
      str = "${monthesD.toStringAsFixed(1)} months";
    else if (days == 1)
      str = "$days day";
    else if (days > 0)
      str = "${daysD.toStringAsFixed(1)} days";
    else if (hours == 1)
      str = "$hours hour";
    else if (hours > 0)
      str = "${hoursD.toStringAsFixed(1)} hours";
    else if (minutes == 1)
      str = "$minutes min";
    else if (minutes > 0)
      str = "${minutesD.toStringAsFixed(1)} mins";
    else if (seconds == 1) str = "$seconds sec";

    if (happened)
      return "$str ago";
    else
      return "$str";
  }

  String finishDateToString(DateTime finishDate, int msToFinish) {
    bool happened = msToFinish <= 0;
    msToFinish = msToFinish.abs();

    DateFormat formatter = new DateFormat('dd.MM.yy');
    if (msToFinish < 1000 * 60 * 60 * 24) formatter = new DateFormat('jm');
    if (happened)
      return "was at ${formatter.format(finishDate)}";
    else
      return "to ${formatter.format(finishDate)}";
  }

  @override
  Widget build(BuildContext buildContext) {
    DateTime nowTime = DateTime.now();
    int nowMs = nowTime.millisecondsSinceEpoch;
    int taskDeadlineMs = widget.task.deadline.millisecondsSinceEpoch;
    int maxDeadlineMs = widget.maxDeadline.millisecondsSinceEpoch;
    int minDeadlineMs = widget.minDeadline.millisecondsSinceEpoch;
    int diffMs = taskDeadlineMs - nowMs;
    bool happened = diffMs <= 0;
    diffMs = diffMs.abs();

    double coeff = 1 -
        (diffMs) /
            (happened ? (nowMs - minDeadlineMs) : (maxDeadlineMs - nowMs));
    coeff = math.pow(coeff, widget.viewConfig.valuePower);

    return ListTile(
      title: new Container(
        margin: EdgeInsets.only(bottom: 3.0),
        child: Text(widget.task.name),
      ),
      subtitle: new Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              width: coeff == 0.0
                  ? 2.0
                  : MediaQuery.of(buildContext).size.width * coeff,
              decoration: new ShapeDecoration(
                shape: new Border.all(
                  color: happened ? Colors.green : Colors.red,
                  width: 2.0,
                ),
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
      ),
      leading: Checkbox(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
