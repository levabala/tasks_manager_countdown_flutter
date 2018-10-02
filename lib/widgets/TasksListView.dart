import 'package:flutter/material.dart';
import 'package:todo_countdown/classes/Events.dart';
import 'package:todo_countdown/classes/Filter.dart';
import 'package:todo_countdown/classes/TaskC.dart';
import 'package:todo_countdown/widgets/TaskListItem.dart';
import 'package:todo_countdown/managers/TasksManager.dart';
import 'package:todo_countdown/managers/FiltersManager.dart';
import 'package:todo_countdown/managers/ViewConfigsManager.dart';

class TasksListView extends StatefulWidget {
  static TasksListViewState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<TasksListViewState>());
  TasksListView();

  @override
  TasksListViewState createState() => new TasksListViewState();
}

class TasksListViewState extends State<TasksListView> {
  var listItemsKeys = new Map<String, GlobalKey<TaskListItemState>>();
  var checkedTaskNames = Map<String, bool>();
  List<TaskC> tasksFiltered, tasksFilteredPast;
  DateTime maxDeadline, minDeadline, maxDeadlinePast, minDeadlinePast;
  void updateTasks() {
    if (!filtersManager.filters.containsKey("filter1"))
      filtersManager.setFilter(id: "filter1", filter: Filter());
    tasksFiltered = filtersManager.filters["filter1"].filterList(tasksManager
        .tasks
        .where(
            (task) => task.deadlineMs > DateTime.now().millisecondsSinceEpoch)
        .toList());
    tasksFilteredPast = filtersManager.filters["filter1"].filterList(
        tasksManager.tasks
            .where((task) =>
                task.deadlineMs <= DateTime.now().millisecondsSinceEpoch)
            .toList());
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
  }

  @override
  Widget build(BuildContext buildContext) {
    updateTasks();

    eventBus.on<TasksAddedEvent>().listen((event) {
      setState(() {});
    });

    return ListView.builder(
      itemCount: tasksFiltered.length,
      itemBuilder: (context, index) {
        final task = tasksFiltered[index];
        listItemsKeys[task.name] =
            GlobalKey<TaskListItemState>(debugLabel: task.name);
        return Dismissible(
          key: Key(task.name),
          onDismissed: (direction) {
            setState(() {
              checkedTaskNames.remove(task.name);
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
            viewConfig: viewConfigsManager.configs["main"],
          ),
        );
      },
    );
  }
}
