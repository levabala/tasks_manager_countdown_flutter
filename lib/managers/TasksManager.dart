import 'dart:convert';
import 'package:todo_countdown/classes/Events.dart';
import 'package:todo_countdown/classes/TaskC.dart';
import 'package:todo_countdown/managers/AppConfigurator.dart'
    show appConfigurator;

class _TasksManager {
  DateTime maxDeadline = DateTime.fromMicrosecondsSinceEpoch(0);
  DateTime minDeadline = new DateTime(2100);
  List<TaskC> tasks = [];

  bool isNameFree(String name) {
    return !tasks.any((t) => t.name.toLowerCase() == name.toLowerCase());
  }

  bool addTask({TaskC task, bool oneOfMany = false}) {
    if (!isNameFree(task.name)) return false;
    tasks.add(task);
    if (task.deadline.compareTo(maxDeadline) == 1) maxDeadline = task.deadline;
    if (task.deadline.compareTo(minDeadline) == -1) minDeadline = task.deadline;
    tasks.sort((task1, task2) {
      return task1.deadline.compareTo(task2.deadline);
    });

    if (!oneOfMany) {
      eventBus.fire(new TasksAddedEvent([task]));
      appConfigurator.writeToStorage();
    }

    return true;
  }

  void removeTask({TaskC task, bool oneOfMany = false}) {
    tasks.remove(task);
    if (!oneOfMany) {
      eventBus.fire(new TasksRemovedEvent([task]));
      appConfigurator.writeToStorage();
    }
  }

  void addTasks(List<TaskC> tasks) {
    for (TaskC task in tasks) addTask(task: task, oneOfMany: true);
    eventBus.fire(new TasksAddedEvent(tasks));
    appConfigurator.writeToStorage();
  }

  void loadJSONData(json) {
    var data = jsonDecode(json);
    List<TaskC> tasksToAdd = [];
    for (var task in data) {
      tasksToAdd.add(TaskC.fromJSON(task));
    }

    addTasks(tasksToAdd);
  }

  String toJSON() {
    List<String> data = [];
    for (var task in tasks) {
      data.add(task.toJSON());
    }
    var json = jsonEncode(data);
    return json;
  }
}

_TasksManager tasksManager = _TasksManager();
