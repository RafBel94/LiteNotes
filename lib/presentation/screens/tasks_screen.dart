import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/task.dart';
import 'package:simple_notes/domain/entities/task_check.dart';
import 'package:simple_notes/presentation/screens/providers/recicle_bin_provider.dart';
import 'package:simple_notes/presentation/screens/providers/task_provider.dart';
import 'package:simple_notes/presentation/screens/user_task_screen.dart';
import 'package:simple_notes/presentation/widgets/dialogs/confirmation_dialog.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {

  final TaskProvider taskProvider = context.watch<TaskProvider>();

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(taskProvider.taskList.length, (index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(25, 158, 158, 158),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(taskProvider.taskList[index].title, style: const TextStyle(fontSize: 22, color: Colors.white),),
                            Text('Creation date:  ${taskProvider.taskList[index].creationDate.toIso8601String().split('T').first}', style: const TextStyle(fontSize: 15, color: Colors.white70),),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text('${countDoneChecks(index, taskProvider.taskList[index].checkList)}/${taskProvider.taskList[index].checkList.length}',
                          style: const TextStyle(fontSize: 30)),
                        )
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => UserTaskScreen(task: taskProvider.taskList[index]),),);
                  },
                  onLongPress: () => showLongPressMenu(context, taskProvider.taskList[index]),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
  
  String countDoneChecks(int index, List<TaskCheck> checkList) {
    int doneChecks = 0;

    for(TaskCheck taskCheck in checkList){
      if(taskCheck.done){
        doneChecks++;
      }
    }

    return doneChecks.toString();
  }

  showLongPressMenu(BuildContext context, Task task) {

    TaskProvider taskProvider = context.read<TaskProvider>();
    RecicleBinProvider recicleBinProvider = context.read<RecicleBinProvider>();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                        builder: (context) => UserTaskScreen(task: task)
                    )
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  ConfirmationDialog(context: context, message: 'Do you really want to delete this task?').showConfirmationDialog(context).then((confirmation) {
                    if (confirmation == true) {
                      recicleBinProvider.addTask(task);
                      taskProvider.removeTask(task);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
