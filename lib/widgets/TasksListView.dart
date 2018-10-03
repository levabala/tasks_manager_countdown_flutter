import 'package:flutter/material.dart';
import 'package:todo_countdown/classes/Events.dart';
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
  var checkedTaskNames = Map<String, bool>();
  var anythingChecked = false;
  List<TaskC> tasksFiltered, tasksFilteredAfter, tasksFilteredPast;
  DateTime maxDeadline, minDeadline, maxDeadlinePast, minDeadlinePast;

  void updateTasks() {
    tasksFiltered =
        filtersManager.filters["default"].filterList(tasksManager.tasks);
    tasksFilteredAfter = tasksManager.getAllTaskAfterNow(tasks: tasksFiltered);
    tasksFilteredPast = tasksManager.getAllTaskBeforeNow(tasks: tasksFiltered);

    if (tasksFilteredAfter.length > 0) {
      maxDeadline = tasksManager.findLatestTask(tasksFilteredAfter).deadline;
      minDeadline = tasksManager.findEarliestTask(tasksFilteredAfter).deadline;
    }
    if (tasksFilteredPast.length > 0) {
      maxDeadlinePast = tasksManager.findLatestTask(tasksFilteredPast).deadline;
      minDeadlinePast =
          tasksManager.findEarliestTask(tasksFilteredPast).deadline;
    }

    List<String> toRemove = [];
    for (var name in checkedTaskNames.keys)
      if (!tasksFiltered.any((task) => task.name == name)) toRemove.add(name);

    for (var name in toRemove) checkedTaskNames.remove(name);
  }

  void onCheckingChanged() {
    anythingChecked = checkedTaskNames.values.any((isChecked) => isChecked);
  }

  void updateTaskChecked({String taskName, bool checked}) {
    checkedTaskNames[taskName] = checked;
    print(checkedTaskNames);
    onCheckingChanged();
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
          background:
              Container(color: anythingChecked ? Colors.red : Colors.green),
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
