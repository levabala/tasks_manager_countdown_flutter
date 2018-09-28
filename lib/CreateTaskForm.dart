import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:tasks_manager_countdown_flutter/TaskC.dart';

class AddTaskForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  AddTaskForm({@required this.formKey, stateKey}) : super(key: stateKey);

  @override
  AddTaskFormState createState() {
    return AddTaskFormState();
  }
}

class TaskAddFormState extends FormState {
  TaskC task = new TaskC();
  TaskAddFormState();
}

class AddTaskFormState extends State<AddTaskForm> {
  TaskC task = new TaskC();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            autofocus: true,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(hintText: "Task name..."),
            onEditingComplete: () {
              widget.formKey.currentState.validate();
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
            onSaved: (name) {
              task.name = name;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration:
                InputDecoration(hintText: "Task description (multiline)..."),
            onEditingComplete: () {
              widget.formKey.currentState.validate();
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
            onSaved: (description) {
              task.description = description;
            },
          ),
          DateTimePickerFormField(
            format: new DateFormat("'Finish date:' MMMM d, yyyy 'at' h:mma"),
            decoration: InputDecoration(hintText: "Finish date&time"),
            onChanged: (date) {
              widget.formKey.currentState.validate();
            },
            validator: (value) {
              if (value == null) {
                return 'Please pick a date';
              }
            },
            onSaved: (datetime) {
              task.deadline = datetime;
            },
          ),
        ],
      ),
    );
  }
}
