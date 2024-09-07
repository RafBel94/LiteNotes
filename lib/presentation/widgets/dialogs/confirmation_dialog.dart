import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          title: Text(AppLocalizations.of(context)!.confirmation),
          content: Text(message, style: const TextStyle(fontSize: 18)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(AppLocalizations.of(context)!.accept, style: const TextStyle(fontSize: 18)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }
}
