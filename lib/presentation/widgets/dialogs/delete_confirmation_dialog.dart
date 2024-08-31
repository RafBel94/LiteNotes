import 'package:flutter/material.dart';

class DeleteConfirmationDialog {
  BuildContext context;
  String type;

  DeleteConfirmationDialog({required this.context, required this.type});

  Future<bool?> showConfirmationDialog(BuildContext context) {

    final String entityType = (type == 'note') ? 'note' : 'task';

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 53, 53, 53),
          title: const Text("Delete Confirmation"),
          content: Text("Do you want to delete this $entityType?", style: const TextStyle(fontSize: 18)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel", style: TextStyle(fontSize: 18)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Accept", style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }
}
