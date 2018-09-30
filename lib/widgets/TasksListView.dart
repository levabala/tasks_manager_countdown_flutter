import 'package:flutter/material.dart';
import 'package:todo_countdown/classes/Events.dart';
import 'package:todo_countdown/classes/Filter.dart';
import 'package:todo_countdown/classes/TaskC.dart';
import 'package:todo_countdown/widgets/TaskListItem.dart';
import 'package:todo_countdown/managers/TasksManager.dart';
import 'package:todo_countdown/managers/FiltersManager.dart';
import 'package:todo_countdown/managers/ViewConfigsManager.dart';

class TasksListView extends StatefulWidget {
  TasksListView();

  @override
  TasksListViewState createState() => new TasksListViewState();
}

class TasksListViewState extends State<TasksListView> {
  @override
  Widget build(BuildContext buildContext) {
    if (!filtersManager.filters.containsKey("filter1"))
      filtersManager.setFilter(id: "filter1", filter: Filter());
    List<TaskC> tasksFiltered = filtersManager.filters["filter1"].filterList(
        tasksManager.tasks
            .where((task) =>
                task.deadlineMs > DateTime.now().millisecondsSinceEpoch)
            .toList());
    List<TaskC> tasksFilteredPast = filtersManager.filters["filter1"]
        .filterList(tasksManager.tasks
            .where((task) =>
                task.deadlineMs <= DateTime.now().millisecondsSinceEpoch)
            .toList());
    DateTime maxDeadline, minDeadline, maxDeadlinePast, minDeadlinePast;
    maxDeadline =
        minDeadline = maxDeadlinePast = minDeadlinePast = DateTime.now();
    if (tasksFiltered.length > 0) {
      maxDeadline = tasksFiltered
          .reduce((maxTask, task) =>
              task.deadlineMs > maxTask.deadlineMs ? task : maxTask)
          .deadline;
      minDeadline = tasksFiltered
          .reduce((minTask, task) =>
              task.deadlineMs < minTask.deadlineMs ? task : minTask)
          .deadline;
    }
    if (tasksFilteredPast.length > 0) {
      maxDeadlinePast = tasksFilteredPast
          .reduce((maxTask, task) =>
              task.deadlineMs > maxTask.deadlineMs ? task : maxTask)
          .deadline;
      minDeadlinePast = tasksFilteredPast
          .reduce((minTask, task) =>
              task.deadlineMs < minTask.deadlineMs ? task : minTask)
          .deadline;
    }

    tasksFilteredPast.addAll(tasksFiltered);
    tasksFiltered = tasksFilteredPast;

    eventBus.on<TasksAddedEvent>().listen((event) {
      setState(() {});
    });

    return ListView.builder(
      itemCount: tasksFiltered.length,
      itemBuilder: (context, index) {
        final task = tasksFiltered[index];
        return Dismissible(
            key: Key(task.name),
            onDismissed: (direction) {
              setState(() {
                tasksManager.removeTask(task: task);
              });

              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text("Task \"${task.name}\" deleted")));
            },
            background: Container(color: Colors.red),
            child: new TaskListItem(
                task: task,
                maxDeadline: maxDeadline,
                minDeadline: minDeadline,
                maxDeadlinePast: maxDeadlinePast,
                minDeadlinePast: minDeadlinePast,
                viewConfig: viewConfigsManager.configs["main"]));
      },
    );
  }
}
