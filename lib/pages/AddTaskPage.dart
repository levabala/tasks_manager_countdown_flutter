import 'package:flutter/material.dart';
import '../CreateTaskForm.dart';

class AddTaskPage extends StatefulWidget {
  @override
  AddTaskPageState createState() {
    return AddTaskPageState();
  }
}

class AddTaskPageState extends State<AddTaskPage> {
  final addTaskFormKey = new GlobalKey<FormState>();
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
            AddTaskForm(formKey: addTaskFormKey),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          bool validated = addTaskFormKey.currentState.validate();
          print(validated);
          if (validated) {
            _scaffoldKey.currentState
                .showSnackBar(SnackBar(content: Text('Track saved')));
            FocusScope.of(context).requestFocus(new FocusNode());
          }
        },
        tooltip: 'Save',
        child: new Icon(Icons.save),
      ),
    );
  }
}
