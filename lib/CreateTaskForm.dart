import 'package:flutter/material.dart';

class AddTaskForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  AddTaskForm({@required this.formKey});

  @override
  AddTaskFormState createState() {
    return AddTaskFormState();
  }
}

class AddTaskFormState extends State<AddTaskForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(hintText: "Task name..."),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration:
                InputDecoration(hintText: "Task description (multiline)..."),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
        ],
      ),
    );
  }
}
