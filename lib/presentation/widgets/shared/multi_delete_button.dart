import 'package:flutter/material.dart';

class MultiDeleteButton extends StatelessWidget {
  final VoidCallback onDelete;
  const MultiDeleteButton({
    super.key, required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: onDelete,
    );
  }
}