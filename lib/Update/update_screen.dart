import 'package:flutter/material.dart';
import 'package:todo_app/Common/common_drawer.dart';
import 'package:todo_app/Common/todo.dart';
import 'package:todo_app/Common/todo_controller.dart';

//! DEPRECATED , USE UPDATE_DIALOG INSTEAD
class UpdateTodo extends StatefulWidget {
  final Todo todo;
  
  const UpdateTodo({super.key, required this.todo});

  @override
  State<UpdateTodo> createState() => _UpdateTodoState();
}

class _UpdateTodoState extends State<UpdateTodo> {
  final _formKey = GlobalKey<FormState>();

  final _nameBinding = TextEditingController();

  late bool favorite;
  late bool done;
  

  @override
  void initState() {
    super.initState();

    setState(() {
      favorite = widget.todo.favorite;
      done = widget.todo.done;
      _nameBinding.text = widget.todo.name;
    });
  }

  @override
  void dispose() {
    _nameBinding.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Todo #${widget.todo.id}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), 
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(widget.todo.toString()),
              ListTile(
                title: 
              TextFormField(
                validator: (text) {
                  if(text == null || text.isEmpty) {
                    return 'Name can\'t be null';
                  }
                  return null;
                },
                controller: _nameBinding
              ),
              ),
              CheckboxFormField(
                title: const Text("Favorite"),
                initialValue: widget.todo.favorite,
                onChanged: (newValue) {
                  favorite = newValue ?? false;
                },
              ),
              CheckboxFormField(
                title: const Text("Done"),
                initialValue: widget.todo.done,
                onChanged: (newValue) { 
                  done = newValue ?? false; 
                },
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Submit")
              )
            ],
          )
        )
      ),
    );
  }

  void _submitForm() {
    Todo todo = Todo.from(widget.todo);

    todo.name = _nameBinding.text;
    todo.favorite = favorite;
    todo.done = done;

    TodoController().updateTodo(todo).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Successfully updated Todo #${todo.id}"))
      );
      Navigator.of(context).pop(todo);
    });
  }
}

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {
        super.key,
        Widget? title,
        ValueChanged<bool?>? onChanged,
      FormFieldSetter<bool>? onSaved,
      FormFieldValidator<bool>? validator,
      bool initialValue = false,
      bool autovalidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              void onChangedHandler(bool? value) {
                state.didChange(value);
                if(onChanged != null) {
                  onChanged(value);
                }
              }

              return CheckboxListTile(
                dense: state.hasError,
                title: title,
                value: state.value,
                onChanged: onChangedHandler,
                subtitle: state.hasError
                    ? Builder(
                        builder: (BuildContext context) =>  Text(
                          state.errorText!,
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                      )
                    : null,
                controlAffinity: ListTileControlAffinity.leading,
              );
            });
}
