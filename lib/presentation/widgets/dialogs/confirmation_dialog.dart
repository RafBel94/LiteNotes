import 'package:flutter/material.dart';

class ConfirmationDialog {
  BuildContext context;
  String message;

  ConfirmationDialog({required this.context, required this.message});

  Future<bool?> showConfirmationDialog(BuildContext context) {

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 53, 53, 53),
          title: const Text("Confirmation"),
          content: Text(message, style: const TextStyle(fontSize: 18)),
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
