import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/task.dart';
import 'package:simple_notes/domain/entities/task_check.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_notes/presentation/screens/deleted_task_screen.dart';
import 'package:simple_notes/presentation/screens/providers/multiselect_provider.dart';
import 'package:simple_notes/presentation/screens/providers/recicle_bin_provider.dart';
import 'package:simple_notes/presentation/screens/providers/task_provider.dart';
import 'package:simple_notes/presentation/widgets/dialogs/confirmation_dialog.dart';
import 'package:simple_notes/presentation/widgets/shared/multi_delete_button.dart';
import 'package:simple_notes/presentation/widgets/shared/multi_restore_button.dart';
import 'package:simple_notes/presentation/widgets/shared/multiselection_cancel_button.dart';
import 'package:simple_notes/presentation/widgets/sort_button.dart';

class RecicleBinTasksScreen extends StatefulWidget {
  const RecicleBinTasksScreen({super.key});

  @override
  State<RecicleBinTasksScreen> createState() => _RecicleBinTasksScreenState();
}

class _RecicleBinTasksScreenState extends State<RecicleBinTasksScreen> {
  @override
  Widget build(BuildContext context) {

    final RecicleBinProvider binProvider = context.watch<RecicleBinProvider>();
    final TaskProvider taskProvider = context.read<TaskProvider>();
    final MultiselectProvider multiselectProvider = context.watch<MultiselectProvider>();
    final List<Task> deletedTaskList = binProvider.taskList;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if(didPop){
          if(multiselectProvider.isTasksMultiSelectMode){
            multiselectProvider.toggleTasksMultiSelectMode();
          }
        }
      },
      child: Scaffold(backgroundColor: const Color.fromARGB(255, 23, 23, 23),
        appBar: AppBar(
          actions: [
            if (multiselectProvider.isTasksMultiSelectMode) ...[
              MultiselectionCancelButton(multiselectProvider: multiselectProvider, type: 'task',),
              MultiDeleteButton(onDelete: () =>  deleteSelectedTasks(binProvider, multiselectProvider)),
              MultiRestoreButton(onRestore: () => restoreSelectedTasks(multiselectProvider, taskProvider, binProvider)),
            ],
              
            const SortButton(isDeletedScreen: true, objectType: 'task',)
          ],
          backgroundColor: const Color.fromARGB(255, 254, 204, 54),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.recicle_bin_deleted_tasks_title, style: const TextStyle(color: Colors.black)),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(deletedTaskList.length, (index) {
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromARGB(25, 158, 158, 158),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                          ),
                          onPressed: () {
                            if(!multiselectProvider.isTasksMultiSelectMode){
                              Navigator.push(context,MaterialPageRoute(builder: (context) => DeletedTaskScreen(task: deletedTaskList[index]),),);
                            } else {
                              multiselectProvider.toggleTaskSelection(deletedTaskList[index]);
                            }
                          },
                          onLongPress: () {
                            multiselectProvider.toggleTasksMultiSelectMode();
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(deletedTaskList[index].title, style: const TextStyle(fontSize: 22, color: Colors.white),),
                                    Text('${AppLocalizations.of(context)!.delete_date}  ${deletedTaskList[index].deletedDate?.toIso8601String().split('T').first}', style: const TextStyle(fontSize: 15, color: Colors.white70),),
                                  ],
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 30),
                                  child: Text('${countDoneChecks(index, deletedTaskList[index].checkList)}/${deletedTaskList[index].checkList.length}',
                                  style: const TextStyle(fontSize: 30)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
      
                    if (multiselectProvider.isTasksMultiSelectMode)
                    Positioned(
                      top: 8,
                      right: -2,
                      child: Radio(
                        groupValue: true,
                        toggleable: true,
                        value: multiselectProvider.selectedTasks.contains(deletedTaskList[index]),
                        onChanged: (value) {
                          multiselectProvider.toggleTaskSelection(deletedTaskList[index]);
                        },
                      ),
                    ),
                  ]
                );
              }),
            ),
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

  void restoreSelectedTasks(MultiselectProvider multiselectProvider, TaskProvider taskProvider, RecicleBinProvider binProvider) {
    ConfirmationDialog(context: context, message: AppLocalizations.of(context)!.confirmation_dialog_recover_tasks).showConfirmationDialog(context).then((confirmation) {
      if (confirmation == true) {
        binProvider.removeTasks(multiselectProvider.selectedTasks);
        taskProvider.addTasks(multiselectProvider.selectedTasks);
      }
        multiselectProvider.toggleTasksMultiSelectMode();
    });
  }

  void deleteSelectedTasks(RecicleBinProvider binProvider, MultiselectProvider multiselectProvider) {
    ConfirmationDialog(context: context, message: AppLocalizations.of(context)!.confirmation_dialog_delete_tasks).showConfirmationDialog(context).then((confirmation) {
      if (confirmation == true) {
        binProvider.removeTasks(multiselectProvider.selectedTasks);
      }
        multiselectProvider.toggleTasksMultiSelectMode();
    });
  }
}
