import 'package:flutter/material.dart';
import 'package:todo_countdown/classes/Events.dart';
import 'package:todo_countdown/classes/TaskC.dart';
import 'package:todo_countdown/widgets/TaskListItem.dart';
import 'package:todo_countdown/managers/TasksManager.dart';
import 'package:todo_countdown/managers/FiltersManager.dart';
import 'package:todo_countdown/managers/ViewConfigsManager.dart';

class TasksListView extends StatefulWidget {
  // global accessor to make it visible from its children (taskItems)
  static TasksListViewState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<TasksListViewState>());

  // callbacks
  final Function onAnyCheckedCallback, onAllUnchecked;

  TasksListView(
      {@required this.onAnyCheckedCallback, @required this.onAllUnchecked});

  @override
  TasksListViewState createState() => new TasksListViewState();
}

class TasksListViewState extends State<TasksListView> {
  // here we contain pairs (TaskName : isChecked)
  var checkedTaskNames = Map<String, bool>();
  // shortcut for checking state
  var anythingChecked = false;
  // lists of tasks to render different ways
  List<TaskC> tasksFiltered, tasksFilteredAfter, tasksFilteredPast;
  // data collecting during filtering tasks to make nice items rendering
  DateTime maxDeadline, minDeadline, maxDeadlinePast, minDeadlinePast;

  void updateTasks() {
    // let's get everything what chosen filter approves
    tasksFiltered =
        filtersManager.filters["default"].filterList(tasksManager.tasks);
    // now save what's going after nowTime
    tasksFilteredAfter = tasksManager.getAllTaskAfterNow(tasks: tasksFiltered);
    // and before
    tasksFilteredPast = tasksManager.getAllTaskBeforeNow(tasks: tasksFiltered);

    // we can find max/min deadline only when there are at least one task
    if (tasksFilteredAfter.length > 0) {
      // we use method of global instance of _TasksManager (private class)
      maxDeadline = tasksManager.findLatestTask(tasksFilteredAfter).deadline;
      minDeadline = tasksManager.findEarliestTask(tasksFilteredAfter).deadline;
    }
    if (tasksFilteredPast.length > 0) {
      maxDeadlinePast = tasksManager.findLatestTask(tasksFilteredPast).deadline;
      minDeadlinePast =
          tasksManager.findEarliestTask(tasksFilteredPast).deadline;
    }

    // at the end of updating cycle we need to remove disappeared items
    List<String> toRemove = [];
    for (var name in checkedTaskNames.keys)
      if (!tasksFiltered.any((task) => task.name == name)) toRemove.add(name);
    for (var name in toRemove) checkedTaskNames.remove(name);
  }

  void onCheckingChanged() {
    anythingChecked = checkedTaskNames.values.any((isChecked) => isChecked);

    // calling TasksPage callback after checking/unchecking
    if (anythingChecked)
      widget.onAnyCheckedCallback(
          checkedTaskNames.removeWhere((name, checked) => !checked));
    else
      widget.onAllUnchecked();
  }

  // task item checked hadler
  void updateTaskChecked({String taskName, bool checked}) {
    checkedTaskNames[taskName] = checked;
    onCheckingChanged();
  }

  @override
  Widget build(BuildContext buildContext) {
    // first after-build update
    updateTasks();

    // starting listening for global events from _TasksManager
    eventBus.on<TasksAddedEvent>().listen((event) {
      // just calling rebuilding (updating state whereas it's statefulWidget)
      setState(() {});
    });

    return ListView.builder(
      itemCount: tasksFiltered.length,
      itemBuilder: (context, index) {
        final task = tasksFiltered[index];
        // creating tile which can be "dismissed" by swiping left or right
        return Dismissible(
          // by some reason dismissible must have key
          key: Key(task.name),
          onDismissed: (direction) {
            // update our model
            setState(() {
              checkedTaskNames.remove(task.name);
              tasksManager.removeTask(task: task);
            });
            // showing message about deleting
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
