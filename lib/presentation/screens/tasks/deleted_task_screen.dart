import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/task.dart';
import 'package:simple_notes/domain/entities/task_check.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_notes/presentation/screens/providers/recicle_bin_provider.dart';
import 'package:simple_notes/presentation/screens/providers/task_provider.dart';
import 'package:simple_notes/presentation/widgets/dialogs/confirmation_dialog.dart';
import 'package:simple_notes/presentation/widgets/shared/textfields/title_text_field.dart';

class DeletedTaskScreen extends StatefulWidget {

  final Task task;

  const DeletedTaskScreen({super.key, required this.task});

  @override
  State<DeletedTaskScreen> createState() => _DeletedTaskScreenState();
}

class _DeletedTaskScreenState extends State<DeletedTaskScreen> {

  TextEditingController titleController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  List<TaskCheck> checkList = [];
  List<TextEditingController> controllerList = [];
  List<FocusNode> focusList = [];

  @override
  void initState() {
    super.initState();

    titleController.text = widget.task.title;
    checkList = widget.task.checkList;
    
    _setControllersLists();
  }

  @override
  void dispose() {
    titleController.dispose();
    titleFocusNode.dispose();

    for (TextEditingController controller in controllerList) {
      controller.dispose();
    }

    for (FocusNode focus in focusList) {
      focus.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

  final RecicleBinProvider binProvider = context.read<RecicleBinProvider>();
  final TaskProvider taskProvider = context.read<TaskProvider>();

    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.black,
          ),
          backgroundColor: const Color.fromARGB(255, 254, 204, 54),
          centerTitle: true,
          title: Text(widget.task.title, style: const TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.delete, color: Colors.black, size: 30),
                onPressed: () {
                  ConfirmationDialog(context: context, message: AppLocalizations.of(context)!.confirmation_dialog_delete_task).showConfirmationDialog(context).then((confirmation) {
                    if (confirmation == true) {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      binProvider.removeTask(widget.task);
                    }
                  });
                }),

            IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black, size: 30),
            onPressed: () {
              ConfirmationDialog(context: context, message: AppLocalizations.of(context)!.confirmation_dialog_recover_task).showConfirmationDialog(context).then((confirmation) {
                if (confirmation == true) {
                  widget.task.deletedDate = null;
                  taskProvider.addTask(widget.task);
                  binProvider.removeTask(widget.task);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              });
            }),
          ],
        ),
    
        body: Container(
          decoration: const BoxDecoration(color: Color.fromARGB(255, 24, 24, 24)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 5),
    
                Container(margin: const EdgeInsets.only(bottom: 10), child: Text(AppLocalizations.of(context)!.task_screen_task_title, style: const TextStyle(fontSize: 20))),
    
                TitleTextField(titleController: titleController, titleFocusNode: titleFocusNode, isEnabled: false),
    
                Container(margin: const EdgeInsets.only(top: 35, bottom: 10), child: Text(AppLocalizations.of(context)!.task_screen_task_checklist, style: const TextStyle(fontSize: 20))),
                
                Expanded(
                  child: IgnorePointer(
                    ignoring: true,
                    child: SingleChildScrollView(
                      child: Column(
                        // Here instead of using a ListView.builder, we use a SingleChildScrollView so we can scroll through
                        // all the task checks, and in this column, instead of creating the widgets manually, we do it through
                        // a List.generate that use the length of the checkList from the provider
                        children: List.generate(checkList.length, (index) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                    
                                // Check Button
                                IconButton(
                                  icon: checkList[index].done ? const Icon(Icons.check_box_outlined, color: Color.fromARGB(255, 81, 81, 81)) : const Icon(Icons.check_box_outline_blank_outlined, color: Color.fromARGB(255, 81, 81, 81),),
                                  onPressed: () {
                                    setState(() {
                                      checkList[index].done = !checkList[index].done;
                                    });
                                  },
                                ),
                    
                                // TaskCheck Text
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 15, right: 30),
                                    child: TextField(
                                      controller: controllerList[index],
                                      focusNode: focusList[index],
                                      style: checkList[index].done ? 
                                        const TextStyle(color: Color.fromARGB(255, 81, 81, 81), decoration: TextDecoration.lineThrough) :
                                        const TextStyle(color: Color.fromARGB(255, 81, 81, 81)),
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!.task_screen_todo_textfield_hint,
                                        hintStyle: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 70, 69, 69)),
                                        contentPadding: const EdgeInsets.only(top: 15),
                                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 81, 81, 81))),
                                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 81, 81, 81))),
                                      ),
                                      onTapOutside: (event) {
                                        focusList[index].unfocus();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
    
                const SizedBox(height: 15,)
              ],
            ),
          ),
        ),
      );
  }
  
  
  void _setControllersLists() {
    controllerList.clear();
    focusList.clear();
    
    for(TaskCheck tc in checkList){
      TextEditingController controller = TextEditingController(text: tc.text);
      FocusNode focusNode = FocusNode();

      focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        setState(() {
          if (controller.text.trim().isEmpty) {
            controller.text = AppLocalizations.of(context)!.task_screen_todo_empty_text;
            tc.text = AppLocalizations.of(context)!.task_screen_todo_empty_text;
          } else {
            tc.text = controller.text;
          }
        });
      }
    });

      controllerList.add(controller);
      focusList.add(focusNode);
    }
  }
}

