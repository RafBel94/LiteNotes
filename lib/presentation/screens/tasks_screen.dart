import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/presentation/screens/providers/task_provider.dart';

class TasksScreen extends StatelessWidget {

  const TasksScreen({super.key});


  @override
  Widget build(BuildContext context) {

    final TaskProvider taskProvider = context.watch<TaskProvider>();

    return Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 24, 24, 24)),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: taskProvider.taskList.length,
            itemBuilder: (context, index) {
              // TODO: Create task Widget
              return const Placeholder();
            },
          ),
        )
      );
  }
}