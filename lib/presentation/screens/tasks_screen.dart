import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/presentation/screens/providers/task_provider.dart';

class TasksScreen extends StatelessWidget {

  const TasksScreen({super.key});


  @override
  Widget build(BuildContext context) {

    final TaskProvider taskProvider = context.watch<TaskProvider>();

    return Center(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: taskProvider.taskList.length,
          itemBuilder: (context, index) {
            // TODO: Create task Widget
            return Placeholder();
          },
        )
      );
  }
}