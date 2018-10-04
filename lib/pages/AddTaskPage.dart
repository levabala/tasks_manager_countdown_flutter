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
  // keys for communicating with TasksAddForm
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
            // maybe here would be some more elements?
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        // form validating and sending
        onPressed: () {
          FormState formState = addTaskFormKey.currentState;
          bool validated = formState.validate();
          if (validated) {
            // say every form field to save data into form's task instance
            formState.save();
            // getting task instance
            TaskC task = addTaskStateKey.currentState.task;
            tasksManager.addTask(task: task);
            // showing snackbar on main page
            widget.mainPageKey.currentState
                .showSnackBar(SnackBar(content: Text('Task added')));
            // instantly after return to main page
            Navigator.of(context).pop();
          }
        },
        tooltip: 'Save',
        child: new Icon(Icons.save),
      ),
    );
  }
}
