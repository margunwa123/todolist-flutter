import 'package:flutter/material.dart';
import 'package:todo_app/Common/todo_controller.dart';
import 'package:todo_app/Common/update_dialog.dart';
import 'package:todo_app/Update/update_screen.dart';
import 'package:provider/provider.dart';
import 'db_change_notifier.dart';
import 'todo.dart';

class TodoComponent extends StatelessWidget {
  final Todo todo;
  late final List<Widget> actions;

  TodoComponent({
    super.key,
    required this.todo,
    List<Widget>? actions
  }) : this.actions = actions ?? [];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: ListTile(
                onLongPress: () => _toggleDone(context),
                title: Text(
                  todo.name,
                  style: const TextStyle(
                      fontSize: 18
                    ),
                ))),
        ...actions,
      ],
    );
  }

  void _toggleDone(BuildContext context) {
    TodoController().toggleDone(todo).then((value) {
      Provider.of<DbChangeNotifier>(context, listen: false).notifyChange();
    });
  }
}
