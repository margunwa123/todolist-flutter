import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

enum DeleteAllChoice {
  YES,
  NO
}

class DeleteAllDialog extends StatelessWidget {
  const DeleteAllDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete All Archived"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, DeleteAllChoice.NO);
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey,
            textStyle: TextStyle(
              color: Colors.grey[700],
            )
          ),
          child: const Text("NO"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, DeleteAllChoice.YES);
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,),
          child: const Text("YES"),
        ),
        ],
    );
  }
}
