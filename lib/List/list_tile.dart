import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Common/todo_tile.dart';

import '../Common/db_change_notifier.dart';
import '../Common/todo.dart';
import '../Common/todo_controller.dart';
import '../Common/update_dialog.dart';

class ListTodoComponent extends StatelessWidget {
  const ListTodoComponent({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return TodoComponent(
      todo: todo,
      actions: [
        IconButton(
          onPressed: () => _openUpdateDialog(context),
          icon: const Icon(Icons.edit),
          color: Colors.orange,
        ),
        IconButton(
            onPressed: () => _setFavorite(context),
            icon: const Icon(Icons.star),
            color: todo.favorite ? Colors.amber : Colors.grey[600],
          ),
      ],
    );
  }

  void _setFavorite(BuildContext context) {
    TodoController().toggleFavorite(todo).then((value) {
      Provider.of<DbChangeNotifier>(context, listen: false).notifyChange();
    });
  }

  void _toggleDone(BuildContext context) {
    TodoController().toggleDone(todo).then((value) {
      Provider.of<DbChangeNotifier>(context, listen: false).notifyChange();
    });
  }

  void _openUpdateDialog(BuildContext context) {
    print(Scaffold.of(context).hasAppBar);
    showDialog<Todo>(
        context: context,
        barrierDismissible: false, // user must tap button to close it
        builder: ((BuildContext context) =>
            UpdateDialog(todo: todo))).then((updatedTodo) {
      if (updatedTodo != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Successfully updated Todo #${updatedTodo.id}")));
      }
    });
  }
}