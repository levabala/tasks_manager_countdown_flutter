import 'package:flutter/material.dart';
import 'TaskC.dart';
import './pages/TasksPage.dart';
import 'TasksManager.dart' show tasksManager;

List<TaskC> testTasks = [
  new TaskC(
    name: "Task0",
    deadline: new DateTime(2018, 9, 24, 14, 6),
    tags: ["uni"],
  ),
  new TaskC(
    name: "Task1",
    deadline: new DateTime(2018, 9, 24),
    tags: ["uni", "home"],
  ),
  new TaskC(
    name: "Task2",
    deadline: new DateTime(2018, 10, 2),
    tags: ["tobuy"],
  ),
  new TaskC(name: "Task3", deadline: new DateTime(2018, 9, 25)),
  new TaskC(name: "Task4", deadline: new DateTime(2018, 9, 30)),
  new TaskC(name: "Task5", deadline: new DateTime(2018, 9, 29)),
  new TaskC(
    name: "Task6",
    deadline: new DateTime(2018, 9, 23, 15, 40),
    tags: ["events"],
  ),
  new TaskC(name: "Task7", deadline: new DateTime(2018, 9, 23, 19, 3)),
  new TaskC(
    name: "Task8",
    deadline: new DateTime(2018, 9, 23, 23, 12),
    tags: ["uni"],
  ),
  new TaskC(name: "Task9", deadline: new DateTime(2018, 9, 24, 1, 2)),
  new TaskC(name: "Task10", deadline: new DateTime(2018, 9, 25)),
  new TaskC(name: "Task11", deadline: new DateTime(2018, 9, 23)),
  new TaskC(name: "Task12", deadline: new DateTime(2018, 9, 20)),
  new TaskC(name: "Task13", deadline: new DateTime(2018, 8, 12)),
];

void main() {
  tasksManager.addTasks(testTasks);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TasksManagerCountdown',
      theme: new ThemeData(
        accentColor: Colors.grey[700],
        primaryColor: Colors.grey[800],
        brightness: Brightness.light,
      ),
      home: new TasksPage(),
    );
  }
}
