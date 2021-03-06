import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_countdown/classes/TaskC.dart';
import 'package:todo_countdown/managers/TasksManager.dart' show tasksManager;
import 'package:todo_countdown/managers/FiltersManager.dart'
    show filtersManager;

class _AppConfigurator {
  void writeToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("filters", filtersManager.toJSON());
    prefs.setString("tasks", tasksManager.toJSON());
  }

  Future<bool> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  resetManagers() {
    filtersManager.reset();
    tasksManager.reset();
  }

  void loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    var keys = prefs.getKeys();
    if (keys.length == 0) {
      // nothing here yet
    } else {
      if (keys.contains("filters"))
        filtersManager.loadJSONData(prefs.getString("filters"));
      if (keys.contains("tasks"))
        tasksManager.loadJSONData(prefs.getString("tasks"));
    }
  }

  // some mock data
  void loadTestData() {
    List<TaskC> testTasks = [
      new TaskC(
        name: "Task0",
        deadline: new DateTime(2018, 9, 30, 14, 6),
        tags: ["uni"],
      ),
      new TaskC(
        name: "Task1",
        deadline: new DateTime(2018, 9, 30),
        tags: ["uni", "home"],
      ),
      new TaskC(
        name: "Task2",
        deadline: new DateTime(2018, 10, 2),
        tags: ["tobuy"],
      ),
      new TaskC(name: "Task3", deadline: new DateTime(2018, 9, 31)),
      new TaskC(name: "Task5", deadline: new DateTime(2018, 9, 29)),
      new TaskC(
        name: "Task6",
        deadline: new DateTime(2018, 10, 1, 15, 40),
        tags: ["events"],
      ),
      new TaskC(name: "Task7", deadline: new DateTime(2018, 10, 3, 19, 3)),
      new TaskC(
        name: "Task8",
        deadline: new DateTime(2018, 10, 12, 23, 12),
        tags: ["uni"],
      )
    ];

    tasksManager.addTasks(testTasks);
  }
}

// also global instance
_AppConfigurator appConfigurator = _AppConfigurator();
