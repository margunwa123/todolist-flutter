import 'package:flutter/material.dart';
import 'package:todo_app/Common/adaptive_list.dart';
import 'package:todo_app/Common/todo.dart';

import '../Common/todo_tile.dart';

class TodoList extends StatefulWidget {
  TodoList({
    super.key, 
    required this.todos,
    Widget Function(Todo)? renderFunction
  }) {
    this.renderFunction = renderFunction ?? (Todo todo) => TodoComponent(todo: todo);
  }

  late final Widget Function(Todo) renderFunction;

  final List<Todo> todos;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveList(
        crossAxisCount: 1,
        items: widget.todos, 
        breakpointAxisPairings: const [
          BreakpointAxisPairing(breakpoint: 600, crossAxisCount: 2)
        ],
        renderFunction: widget.renderFunction,
      );
  }
}