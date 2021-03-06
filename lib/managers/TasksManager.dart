import 'dart:convert';
import 'package:todo_countdown/classes/Events.dart';
import 'package:todo_countdown/classes/TaskC.dart';
import 'package:todo_countdown/managers/AppConfigurator.dart'
    show appConfigurator;

// we have this class private (_) to avoid creating more than 1 instances
class _TasksManager {
  DateTime maxDeadline = DateTime.fromMicrosecondsSinceEpoch(0);
  DateTime minDeadline = new DateTime(2100);
  List<TaskC> tasks = [];

  bool isNameFree(String name) {
    return !tasks.any((t) => t.name.toLowerCase() == name.toLowerCase());
  }

  void reset() {
    maxDeadline = DateTime.fromMicrosecondsSinceEpoch(0);
    minDeadline = new DateTime(2100);
    tasks = [];
  }

  bool addTask({TaskC task, bool oneOfMany = false}) {
    // we mustn't have tasks with same names
    if (!isNameFree(task.name)) return false;
    tasks.add(task);
    // update max&min deadlines
    if (task.deadline.compareTo(maxDeadline) == 1) maxDeadline = task.deadline;
    if (task.deadline.compareTo(minDeadline) == -1) minDeadline = task.deadline;
    // let's have our tasks chronologically ordered
    tasks.sort((task1, task2) {
      return task1.deadline.compareTo(task2.deadline);
    });

    // if it's just a single addition we should notificate about adding
    // other way it should do "addTasks" method
    if (!oneOfMany) {
      // dispatching global event
      eventBus.fire(new TasksAddedEvent([task]));
      // the same reason doing it into the if condition
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
    // notifing'bout adding a collection of task
    eventBus.fire(new TasksAddedEvent(tasks));
    appConfigurator.writeToStorage();
  }

  // parsing json to tasks
  void loadJSONData(json) {
    var data = jsonDecode(json);
    List<TaskC> tasksToAdd = [];
    for (var task in data) tasksToAdd.add(TaskC.fromJSON(task));

    addTasks(tasksToAdd);
  }

  // build-in filtering function
  // (i don't want make it static because we working with instance not prototype)
  List<TaskC> getAllTaskAfterNow({List<TaskC> tasks}) {
    if (tasks == null) tasks = this.tasks;
    if (tasks.length == 0) return [];
    return tasks
        .where(
            (task) => task.deadlineMs > DateTime.now().millisecondsSinceEpoch)
        .toList();
  }

  List<TaskC> getAllTaskBeforeNow({List<TaskC> tasks}) {
    if (tasks == null) tasks = this.tasks;
    if (tasks.length == 0) return [];
    return tasks
        .where(
            (task) => task.deadlineMs < DateTime.now().millisecondsSinceEpoch)
        .toList();
  }

  TaskC findLatestTask(List<TaskC> tasks) {
    return tasks.reduce((maxTask, task) =>
        task.deadlineMs > maxTask.deadlineMs ? task : maxTask);
  }

  TaskC findEarliestTask(List<TaskC> tasks) {
    return tasks.reduce((maxTask, task) =>
        task.deadlineMs < maxTask.deadlineMs ? task : maxTask);
  }

  // encoding
  String toJSON() {
    List<String> data = [];
    for (var task in tasks) {
      data.add(task.toJSON());
    }
    var json = jsonEncode(data);
    return json;
  }
}

// let's create our global instance!
_TasksManager tasksManager = _TasksManager();
