import 'package:flutter/material.dart';
import 'package:tasks_manager_countdown_flutter/TaskC.dart';
import '../CreateTaskForm.dart';
import '../TasksManager.dart' show tasksManager;

class AddTaskPage extends StatefulWidget {
  @override
  AddTaskPageState createState() {
    return AddTaskPageState();
  }
}

class AddTaskPageState extends State<AddTaskPage> {
  //TODO: checkout how TaskAddFormState builds
  final addTaskFormKey = new GlobalKey<FormState>();
  final addTaskStateKey = new GlobalKey<AddTaskFormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
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
            tasksManager.addTask(task);

            _scaffoldKey.currentState
                .showSnackBar(SnackBar(content: Text('Track added')));
            FocusScope.of(context).requestFocus(new FocusNode());
          }
        },
        tooltip: 'Save',
        child: new Icon(Icons.save),
      ),
    );
  }
}
