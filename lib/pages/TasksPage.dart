import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_countdown/widgets/TasksListView.dart';
import 'package:todo_countdown/classes/TasksViewConfig.dart';
import 'package:todo_countdown/pages/AddTaskPage.dart';
import 'package:todo_countdown/pages/TasksFilterPage.dart';

class TasksPage extends StatefulWidget {
  final title = "My Tasks";
  // the thing what we use to set theming of our tasks' view
  final viewConfig = new TasksViewConfig();

  @override
  TasksPageState createState() => new TasksPageState();
}

class TasksPageState extends State<TasksPage> {
  // we use scafforKey to show pretty nice snackbar from TasksFilterPage
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  // "inactive" icons preset for bottomAppBar
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
  // this set we use when any listView items (tasks) are checked
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

  // callback handlers
  void onAnyChecked() {
    //How to connect with TasksListView?
  }

  void onAllUnchecked() {
    //How to connect with TasksListView?
  }

  @override
  Widget build(BuildContext context) {
    // current bar icons set
    List<Widget> bottomAppBarIcons = iconsDefault;
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.filter_list),
            onPressed: () {
              // make navigating to filters page
              Navigator.of(context).push(FilterTaskPageRoute());
            },
          )
        ],
      ),
      // for now body is only ListView (i suppose only now)
      body: new TasksListView(
        onAnyCheckedCallback: onAnyChecked,
        onAllUnchecked: onAllUnchecked,
      ),
      // let's use it for adding new task
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(AddTaskPageRoute(scaffoldKey));
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
      // here we have buttons for operations on checked tasks
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: bottomAppBarIcons,
        ),
      ),
    );
  }
}

// i use custom routes for navigating from page to page
// (sliding horizontally)
class AddTaskPageRoute extends CupertinoPageRoute {
  AddTaskPageRoute(GlobalKey<ScaffoldState> scaffordKey)
      : super(
          builder: (BuildContext context) => new AddTaskPage(
                mainPageKey: scaffordKey,
              ),
        );
}

// yeah, we need to create it for each Route
class FilterTaskPageRoute extends CupertinoPageRoute {
  FilterTaskPageRoute()
      : super(builder: (BuildContext context) => new FilterTaskPage());
}
