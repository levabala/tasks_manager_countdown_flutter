import 'package:flutter/material.dart';
import 'package:todo_countdown/classes/TaskC.dart';
import 'dart:math';

import 'package:todo_countdown/classes/TasksViewConfig.dart';
import 'package:todo_countdown/other/StringGenerators.dart';
import 'package:todo_countdown/widgets/TasksListView.dart';

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

    // we're creating different data for past and future events
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

    // calcing coeff relative on is the task "happened"
    double coeff = maxRange == 0.0
        ? 1.0
        : (happened ? 1 - diffFromMaxMs / maxRange : diffFromMaxMs / maxRange);
    // applying powering to see progressive plot
    coeff = pow(coeff, widget.viewConfig.valuePower);

    // calling parent about checking the item
    void updateParentsInfoAboutMe() {
      TasksListView.of(context)
          .updateTaskChecked(taskName: widget.task.name, checked: checked);
    }

    // let's say that we exist
    updateParentsInfoAboutMe();

    return ListTile(
      // just task name as text
      title: new Container(
        margin: EdgeInsets.only(bottom: 3.0),
        child: Text(widget.task.name),
      ),
      // we create colored container with width which depends on "coeff"
      subtitle: new Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              width: coeff == 0.0
                  // 2.0 - is a minimal width (TODO: make declared)
                  ? 2.0
                  : MediaQuery.of(buildContext).size.width * coeff,
              decoration: new ShapeDecoration(
                shape: new Border.all(
                  color: happened ? Colors.green : Colors.red,
                  width: 2.0,
                ),
              ),
            ),
            // under we have just some additional info'bout task
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
      // a thing for checking our task
      leading: Checkbox(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        value: checked,
        onChanged: (val) {
          setState(() {
            checked = val;
            updateParentsInfoAboutMe();
          });
        },
      ),
    );
  }
}
