import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_app/Common/common_drawer.dart';
import 'package:todo_app/Common/todo_controller.dart';
import 'package:todo_app/Common/todo_tile.dart';
import 'package:todo_app/List/todolist.dart';

import '../Common/todo.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final Future<List<Todo>> _favorites = TodoController().todos(favorites: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Favorites"),
        ),
        body: FutureBuilder(
            future: _favorites,
            builder: ((_, snapshot) {
              if (snapshot.hasData) {
                final favorites = snapshot.data!;

                return TodoList(todos: favorites);
              }

              if (snapshot.hasError) {
                return Text("Error has occured: ${snapshot.error}");
              }

              return const CircularProgressIndicator();
            })));
  }
}
