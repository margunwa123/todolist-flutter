import 'package:flutter/material.dart';
import 'package:todo_app/Common/todo_controller.dart';

import '../Common/todo.dart';

class TodoCreateForm extends StatefulWidget {
  const TodoCreateForm({super.key, this.onCreate});

  final void Function(int)? onCreate;

  @override
  State<TodoCreateForm> createState() => _TodoCreateFormState();
}

class _TodoCreateFormState extends State<TodoCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _todoNameBinding = TextEditingController();

  void submitForm() async { 
    final todo = Todo(name: _todoNameBinding.text);
    final id = await  TodoController().insertTodo(todo);
    _todoNameBinding.clear();
    if(widget.onCreate != null) {
      widget.onCreate!(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _todoNameBinding,
                decoration: const InputDecoration(
                  suffixIcon:  Icon(Icons.abc),
                  hintText: "Todo Name",
                  contentPadding: EdgeInsets.fromLTRB(
                    8,0,8,0
                  ),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Cannot create empty todo';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 8,),
            ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState == null) return;
                if (_formKey.currentState!.validate()) {
                  submitForm();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text("Create"),
            )
          ],
        ));
    }
}
