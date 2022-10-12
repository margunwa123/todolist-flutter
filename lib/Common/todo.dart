class Todo {
  String name;
  int id;
  bool favorite;
  bool done;

  Todo({
    required this.name,
    this.id = -1,
    this.favorite = false,
    this.done = false
  });

  Todo.from(Todo todo): this(id: todo.id, name: todo.name, favorite: todo.favorite, done: todo.done);

  @override
  String toString() {
    String builder = 'Todo {name: $name, favorite: $favorite, done: $done';

    if(id != -1) {
      builder += ', id: $id';
    }
    builder += '}';

    return builder;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'favorite': favorite == true ? 1 : 0,
      'done': done == true ? 1 : 0
    };
  }
}
