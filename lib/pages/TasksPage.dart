import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_countdown/widgets/TasksListView.dart';
import 'package:todo_countdown/classes/TasksViewConfig.dart';
import 'package:todo_countdown/pages/AddTaskPage.dart';
import 'package:todo_countdown/pages/TasksFilterPage.dart';

class TasksPage extends StatefulWidget {
  final title = "My Tasks";
  final viewConfig = new TasksViewConfig();

  @override
  _TasksPageState createState() => new _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Widget> iconsDefault = [
    IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {},
    ),
    IconButton(
      icon: Icon(Icons.search),
      onPressed: () {},
    )
  ];
  List<Widget> iconsCheckedActions = [
    IconButton(
      icon: Icon(Icons.delete),
      onPressed: () {},
    ),
    IconButton(
      icon: Icon(Icons.dashboard),
      onPressed: () {},
    ),
    IconButton(
      icon: Icon(Icons.close),
      onPressed: () {},
    )
  ];

  void updateBottomAppBar() {}

  @override
  Widget build(BuildContext context) {
    List<Widget> bottomAppBarIcons = iconsDefault;
    return new Scaffold(
      key: scaffoldKey,
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
      body: new TasksListView(),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(AddTaskPageRoute(scaffoldKey));
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: Duration(seconds: 3),
        child: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: bottomAppBarIcons,
          ),
        ),
      ),
    );
  }
}

class AddTaskPageRoute extends CupertinoPageRoute {
  AddTaskPageRoute(GlobalKey<ScaffoldState> scaffordKey)
      : super(
          builder: (BuildContext context) => new AddTaskPage(
                mainPageKey: scaffordKey,
              ),
        );
}

class FilterTaskPageRoute extends CupertinoPageRoute {
  FilterTaskPageRoute()
      : super(builder: (BuildContext context) => new FilterTaskPage());
}
