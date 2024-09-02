import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/task.dart';
import 'package:simple_notes/domain/entities/task_check.dart';
import 'package:simple_notes/presentation/screens/deleted_task_screen.dart';
import 'package:simple_notes/presentation/screens/providers/recicle_bin_provider.dart';
import 'package:simple_notes/presentation/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:simple_notes/presentation/widgets/sort_button.dart';

class RecicleBinTasksScreen extends StatelessWidget {
  const RecicleBinTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final RecicleBinProvider binProvider = context.watch<RecicleBinProvider>();
    final List<Task> deletedTaskList = binProvider.taskList; 

    return Scaffold(backgroundColor: const Color.fromARGB(255, 23, 23, 23),
      appBar: AppBar(
        actions: const [
          SortButton()
        ],
        backgroundColor: const Color.fromARGB(255, 254, 204, 54),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text('Deleted Tasks', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(deletedTaskList.length, (index) {
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
                              Text(deletedTaskList[index].title, style: const TextStyle(fontSize: 22, color: Colors.white),),
                              Text('Deletion date:  ${deletedTaskList[index].deletedDate?.toIso8601String().split('T').first}', style: const TextStyle(fontSize: 15, color: Colors.white70),),
                            ],
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text('${countDoneChecks(index, deletedTaskList[index].checkList)}/${deletedTaskList[index].checkList.length}',
                            style: const TextStyle(fontSize: 30)),
                          )
                        ],
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => DeletedTaskScreen(task: deletedTaskList[index]),),);
                    },
                    onLongPress: () => showLongPressMenu(context, deletedTaskList[index]),
                  ),
                ),
              );
            }),
          ),
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

    final RecicleBinProvider recicleBinProvider = context.read<RecicleBinProvider>();

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
                        builder: (context) => DeletedTaskScreen(task: task)
                    )
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  DeleteConfirmationDialog(context: context, type: 'task').showConfirmationDialog(context).then((confirmation) {
                    if (confirmation == true) {
                      recicleBinProvider.removeTask(task);
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
