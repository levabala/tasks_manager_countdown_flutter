import 'package:flutter/material.dart';
import 'TaskC.dart';
import 'TasksPage.dart';
import 'TasksManager.dart' show tasksManager;

List<TaskC> testTasks = [
  new TaskC(name: "Task1", deadline: new DateTime(2018, 9, 24)),
  new TaskC(name: "Task2", deadline: new DateTime(2018, 10, 2)),
  new TaskC(name: "Task3", deadline: new DateTime(2018, 9, 25)),
  new TaskC(name: "Task4", deadline: new DateTime(2018, 9, 30)),
  new TaskC(name: "Task5", deadline: new DateTime(2018, 9, 29)),
  new TaskC(name: "Task5", deadline: new DateTime(2018, 9, 23, 15, 40)),
  new TaskC(name: "Task5", deadline: new DateTime(2018, 9, 23, 19, 3)),
  new TaskC(name: "Task5", deadline: new DateTime(2018, 9, 23, 23, 12)),
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
      theme: new ThemeData(),
      home: new TasksPage(),
    );
  }
}
