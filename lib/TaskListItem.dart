import 'package:flutter/material.dart';
import 'package:todo_countdown/TaskC.dart';
import 'dart:math' as math;
import 'TasksViewConfig.dart';
import 'StringGenerators.dart' show finishDateToString, remainTimeToString;

class TaskListItem extends StatefulWidget {
  final TaskC task;
  final DateTime maxDeadline, maxDeadlinePast;
  final DateTime minDeadline, minDeadlinePast;
  final TasksViewConfig viewConfig;
  TaskListItem({
    @required this.task,
    @required this.maxDeadline,
    @required this.minDeadline,
    @required this.maxDeadlinePast,
    @required this.minDeadlinePast,
    this.viewConfig,
  });

  @override
  TaskListItemState createState() => TaskListItemState();
}

class TaskListItemState extends State<TaskListItem> {
  bool checked = false;

  @override
  Widget build(BuildContext buildContext) {
    DateTime nowTime = DateTime.now();
    int nowMs = nowTime.millisecondsSinceEpoch;
    int taskDeadlineMs = widget.task.deadline.millisecondsSinceEpoch;
    int diffMs = taskDeadlineMs - nowMs;
    bool happened = diffMs <= 0;
    int maxDeadlineMs, minDeadlineMs, diffFromMaxMs, maxRange;
    if (happened) {
      maxDeadlineMs = widget.maxDeadlinePast.millisecondsSinceEpoch;
      minDeadlineMs = widget.minDeadlinePast.millisecondsSinceEpoch;
      maxRange = maxDeadlineMs - minDeadlineMs;
      diffFromMaxMs = maxDeadlineMs - taskDeadlineMs;
      diffMs = diffMs.abs();
    } else {
      maxDeadlineMs = widget.maxDeadline.millisecondsSinceEpoch;
      minDeadlineMs = widget.minDeadline.millisecondsSinceEpoch;
      maxRange = maxDeadlineMs - minDeadlineMs;
      diffFromMaxMs = maxDeadlineMs - taskDeadlineMs;
      diffMs = diffMs.abs();
    }

    double coeff = maxRange == 0.0
        ? 1.0
        : (happened ? 1 - diffFromMaxMs / maxRange : diffFromMaxMs / maxRange);
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
