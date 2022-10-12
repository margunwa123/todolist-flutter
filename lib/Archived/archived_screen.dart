import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Archived/deleteall_dialog.dart';
import 'package:todo_app/Common/common_drawer.dart';
import 'package:todo_app/Common/db_change_notifier.dart';
import 'package:todo_app/Common/todo.dart';
import 'package:todo_app/Common/todo_controller.dart';
import 'package:todo_app/Common/todo_tile.dart';
import 'package:todo_app/List/todolist.dart';

class ArchivedScreen extends StatefulWidget {
  const ArchivedScreen({super.key});

  @override
  State<ArchivedScreen> createState() => _ArchivedScreenState();
}

class _ArchivedScreenState extends State<ArchivedScreen> {
  Future<List<Todo>> _archivedTodos = TodoController().todos(archived: true);

  @override
  void initState() {
    super.initState();

    Provider.of<DbChangeNotifier>(context, listen: false).addListener(() {
      _refresh();
    });
    _refresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _refresh() {
    if(this.mounted) {
      setState(() {
        _archivedTodos = TodoController().todos(archived: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Archived"),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await showDialog<DeleteAllChoice>(context: context, builder: (_) => DeleteAllDialog());

              if(result == DeleteAllChoice.YES) {
                TodoController().delete(archived: true).then((_) {
                  Provider.of<DbChangeNotifier>(context, listen: false).notifyChange();
                });
              }
            },
            icon: const Icon(Icons.delete, color: Colors.red)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _archivedTodos,
          builder: (context, AsyncSnapshot<List<Todo>> snapshot) {
            if(snapshot.hasData) {
              final todos = snapshot.data!;
              
              return TodoList(todos: todos);
            }

            if(snapshot.hasError) {
              return const Text("An Error Occured");
            }

            return CircularProgressIndicator();
          }
        )
      )
    );
  }

  Widget _itemBuilder(Todo todo) {
    return ListTile(
      title: TodoComponent(todo: todo)
    );
  }
}
