import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Common/db_change_notifier.dart';
import 'package:todo_app/Common/todo.dart';
import 'package:todo_app/Common/todo_controller.dart';

class UpdateDialog extends StatefulWidget {
  const UpdateDialog({super.key, required this.todo});

  final Todo todo;

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameBinding = TextEditingController();
  late bool _favorite;
  late bool _done;

  @override
  void initState() {
    super.initState();

    _favorite = widget.todo.favorite;
    _done = widget.todo.done;
  }

  @override
  void dispose() {
    _nameBinding.dispose();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Update Todo#${widget.todo.id}"),
      content: Form(
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
                  _favorite = newValue ?? false;
                },
              ),
              CheckboxFormField(
                title: const Text("Done"),
                initialValue: widget.todo.done,
                onChanged: (newValue) { 
                  _done = newValue ?? false; 
                },
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Submit")
              )
            ],
          )
        )
      ,
    );
  }

  void _submitForm() async {
    Todo todo = Todo(
      name: _nameBinding.text,
      favorite: _favorite,
      done: _done,
      id: widget.todo.id
    );

    await TodoController().updateTodo(todo);
    if(!mounted) return;
    Provider.of<DbChangeNotifier>(context, listen: false).notifyChange();
    Navigator.of(context).pop(todo);
  }
}

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    super.key,
    Widget? title,
    ValueChanged<bool?>? onChanged,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    bool initialValue = false,
    bool autovalidate = false
  }): 
    super(
      validator: validator,
      onSaved: onSaved,
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
          subtitle: state.hasError ? 
            Builder(builder: (context) {
              return Text(
                state.errorText!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              );
            }) : null,
          controlAffinity: ListTileControlAffinity.leading,
        );
      }
    );
}
