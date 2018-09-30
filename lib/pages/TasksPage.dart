import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasks_manager_countdown_flutter/pages/TasksFilterPage.dart';
import 'AddTaskPage.dart';
import '../TasksListView.dart';
import '../TasksViewConfig.dart';

class TasksPage extends StatefulWidget {
  final title = "My Tasks";
  final viewConfig = new TasksViewConfig();

  @override
  _TasksPageState createState() => new _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.filter_list),
            onPressed: () {
              Navigator.of(context).push(FilterTaskPageRoute());
            },
          )
        ],
      ),
      body: new TasksListView(widget.viewConfig),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(AddTaskPageRoute());
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}

class AddTaskPageRoute extends CupertinoPageRoute {
  AddTaskPageRoute()
      : super(builder: (BuildContext context) => new AddTaskPage());
}

class FilterTaskPageRoute extends CupertinoPageRoute {
  FilterTaskPageRoute()
      : super(builder: (BuildContext context) => new FilterTaskPage());
}
