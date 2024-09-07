import 'package:flutter/material.dart';

class MultiRestoreButton extends StatelessWidget {
  final VoidCallback onRestore;
  const MultiRestoreButton({
    super.key, required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
    icon: const Icon(Icons.refresh),
    onPressed: onRestore
    );
  }
}