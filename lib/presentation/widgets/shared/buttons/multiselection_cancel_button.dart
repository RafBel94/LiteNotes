import 'package:flutter/material.dart';
import 'package:simple_notes/presentation/screens/providers/multiselect_provider.dart';

class MultiselectionCancelButton extends StatelessWidget {
  final MultiselectProvider multiselectProvider;
  final String type;
  
  const MultiselectionCancelButton({
    super.key,
    required this.multiselectProvider, required this.type,
  });


  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.cancel_outlined),
      onPressed: () {
        if(type == 'note'){
          multiselectProvider.toggleNotesMultiSelectMode();
        } else if (type == 'task') {
          multiselectProvider.toggleTasksMultiSelectMode();
        }
      },
    );
  }
}