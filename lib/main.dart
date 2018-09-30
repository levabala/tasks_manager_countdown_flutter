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
  appConfigurator.loadFromStorage();
  viewConfigsManager.setConfig("main", TasksViewConfig());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'ToDoCountdown',
      theme: new ThemeData(
        accentColor: Colors.grey[700],
        primaryColor: Colors.grey[800],
        brightness: Brightness.light,
      ),
      home: new TasksPage(),
    );
  }
}
