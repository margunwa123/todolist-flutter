import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Common/common_drawer.dart';
import 'package:todo_app/Common/db_change_notifier.dart';
import 'package:todo_app/Common/todo_controller.dart';
import 'package:todo_app/Archived/archived_screen.dart';
import 'package:todo_app/Common/todo_tile.dart';
import 'package:todo_app/List/list_tile.dart';
import 'package:todo_app/List/todo_form.dart';
import 'package:todo_app/Favorited/favorites_screen.dart';
import 'package:todo_app/List/todolist.dart';

import '../Common/todo.dart';
import 'list_appbar.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Todo> _todos = <Todo>[];
  final _todoNameBinding = TextEditingController();
  final TodoController _todoController = TodoController();

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
    _todoNameBinding.dispose();
    super.dispose();
  }

  void _refresh() {
    _todoController.todos().then((todos) {
      setState(() {
        _todos = todos;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const ListAppbar(),
        drawer: const CommonDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TodoCreateForm(onCreate: _onCreateTodo,),
              const SizedBox(height: 8),
              _todos.isEmpty
            ? const Text("Currently no todo")
            : TodoList(
                todos: _todos,
                renderFunction: (todo) => ListTodoComponent(todo: todo),
              )
            ],
          ),
        ));
  }


  void deleteTodo(Todo todo) {
    _todoController.deleteById(todo.id).then((value) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${todo.toString()} deleted')));
    });
    _refresh();
  }

  void _onCreateTodo(int createdId) {
    ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          'Todo created',
        ),
        action: SnackBarAction(
            label: "Undo", onPressed: () => undoCreation(createdId)),
      ));
      _refresh();
  }

  void undoCreation(int createdId) {
    _todoController.deleteById(createdId).then((_) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Undo Successful')));
    });
    _refresh();
  }


  Widget _listTileBuilder(BuildContext _, int index) {
    final todo = _todos[index];

    return TodoComponent(todo: todo);
  }
}
