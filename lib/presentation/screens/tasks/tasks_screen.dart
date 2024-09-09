import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/presentation/screens/providers/multiselect_provider.dart';
import 'package:simple_notes/presentation/screens/providers/task_provider.dart';
import 'package:simple_notes/presentation/widgets/shared/buttons/task_button.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskProvider taskProvider = context.watch<TaskProvider>();
    final MultiselectProvider multiselectProvider = context.watch<MultiselectProvider>();

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(taskProvider.taskList.length, (index) {
            return TaskButton(
              task: taskProvider.taskList[index],
              isMultiSelectMode: multiselectProvider.isTasksMultiSelectMode,
              isSelected: multiselectProvider.selectedTasks.contains(taskProvider.taskList[index]),
              onLongPress: multiselectProvider.toggleTasksMultiSelectMode,
              onSelected: () => multiselectProvider.toggleTaskSelection(taskProvider.taskList[index]),
              isDeleted: false,
            );
          }),
        ),
      ),
    );
  }
}
