import 'package:flutter/material.dart';
import 'package:todo_countdown/widgets/AddTaskForm.dart';
import 'package:todo_countdown/classes/TaskC.dart';
import 'package:todo_countdown/managers/TasksManager.dart';

class AddTaskPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> mainPageKey;
  AddTaskPage({@required this.mainPageKey});

  @override
  AddTaskPageState createState() {
    return AddTaskPageState();
  }
}

class AddTaskPageState extends State<AddTaskPage> {
  final addTaskFormKey = new GlobalKey<FormState>();
  final addTaskStateKey = new GlobalKey<AddTaskFormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add Task"),
      ),
      body: new Container(
        padding: EdgeInsets.all(10.0),
        child: new Column(
          children: <Widget>[
            AddTaskForm(
              formKey: addTaskFormKey,
              stateKey: addTaskStateKey,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          FormState formState = addTaskFormKey.currentState;
          bool validated = formState.validate();
          if (validated) {
            formState.save();
            TaskC task = addTaskStateKey.currentState.task;
            tasksManager.addTask(task: task);

            widget.mainPageKey.currentState
                .showSnackBar(SnackBar(content: Text('Task added')));
            Navigator.of(context).pop();
            //FocusScope.of(context).requestFocus(new FocusNode());
          }
        },
        tooltip: 'Save',
        child: new Icon(Icons.save),
      ),
    );
  }
}
