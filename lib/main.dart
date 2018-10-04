import 'package:flutter/material.dart';
import 'package:todo_countdown/classes/TasksViewConfig.dart';
import 'package:todo_countdown/managers/ViewConfigsManager.dart';
import './pages/TasksPage.dart';
import 'package:todo_countdown/managers/AppConfigurator.dart'
    show appConfigurator;

void main() {
  loadConfiguration();
  runApp(new MyApp());
}

void loadConfiguration() {
  // loading saved tasks and filters from JSON
  appConfigurator.loadFromStorage();

  // set deafult empty tasks view config
  viewConfigsManager.setConfig("main", TasksViewConfig());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'ToDoCountdown',
      // themes manager?
      theme: new ThemeData(
        accentColor: Colors.grey[700],
        primaryColor: Colors.grey[800],
        brightness: Brightness.light,
      ),
      // let's load the main page
      home: new TasksPage(),
    );
  }
}
