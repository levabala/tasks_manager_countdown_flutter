import 'package:flutter/material.dart';
import 'package:todo_countdown/managers/TasksManager.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:todo_countdown/classes/TaskC.dart';

class AddTaskForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  AddTaskForm({@required this.formKey, stateKey}) : super(key: stateKey);

  @override
  AddTaskFormState createState() {
    return AddTaskFormState();
  }
}

class AddTaskFormState extends State<AddTaskForm> {
  // local task instance
  TaskC task = new TaskC(name: "none");

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            // instantly open keyboard focused on the textfield
            autofocus: true,
            keyboardType: TextInputType.text,
            // dome decor..
            decoration: InputDecoration(
              hintText: "Task name...",
            ),
            // to start priting from capital letter
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              } else if (!tasksManager.isNameFree(value)) {
                return 'Task with the name already exists';
              }
            },
            onSaved: (name) {
              // record data
              task.name = name;
            },
          ),
          TextFormField(
            // expandable
            keyboardType: TextInputType.multiline,
            // to have unlimited count of lines
            maxLines: null,
            decoration:
                InputDecoration(hintText: "Task description (multiline)..."),
            textCapitalization: TextCapitalization.sentences,
            onSaved: (description) {
              task.description = description;
            },
          ),
          DateTimePickerFormField(
            format: new DateFormat("'Finish date:' MMMM d, yyyy 'at' h:mma"),
            decoration: InputDecoration(
              hintText: "Finish date&time",
            ),
            validator: (value) {
              // if user discarded picking date
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
