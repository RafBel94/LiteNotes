import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/task.dart';
import 'package:simple_notes/domain/entities/task_check.dart';
import 'package:simple_notes/presentation/screens/providers/recicle_bin_provider.dart';
import 'package:simple_notes/presentation/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:simple_notes/presentation/widgets/shared/title_text_field.dart';

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

    return PopScope(
      onPopInvokedWithResult: (bool didPop, result) {
        if(didPop){

        }
      },
      child: Scaffold(
          appBar: AppBar(
            leading: const BackButton(
              color: Colors.black,
            ),
            backgroundColor: const Color.fromARGB(255, 254, 204, 54),
            centerTitle: true,
            title: const Text('Task', style: TextStyle(color: Colors.black),
            ),
            actions: [
              IconButton(
                  icon: const Icon(Icons.delete, color: Colors.black, size: 30),
                  onPressed: () {
                    DeleteConfirmationDialog(context: context, type: 'task').showConfirmationDialog(context).then((confirmation) {
                      if (confirmation == true) {
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        binProvider.removeTask(widget.task);
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

                  Container(margin: const EdgeInsets.only(bottom: 10), child: const Text('Task title', style: TextStyle(fontSize: 20))),

                  TitleTextField(titleController: titleController, titleFocusNode: titleFocusNode, isEnabled: false),

                  Container(margin: const EdgeInsets.only(top: 35, bottom: 10), child: const Text('Checklist', style: TextStyle(fontSize: 20))),
                  
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
                                    icon: checkList[index].done ? const Icon(Icons.check_box_outlined, color: Color.fromARGB(255, 81, 81, 81)) : const Icon(Icons.check_box_outline_blank_outlined, color: Color.fromARGB(255, 165, 145, 86),),
                                    onPressed: () {
                                      setState(() {
                                        checkList[index].done = !checkList[index].done;
                                      });
                                    },
                                  ),
                      
                                  // TaskCheck Text
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 15),
                                      child: TextField(
                                        controller: controllerList[index],
                                        focusNode: focusList[index],
                                        style: checkList[index].done ? 
                                          const TextStyle(color: Color.fromARGB(255, 81, 81, 81), decoration: TextDecoration.lineThrough) :
                                          const TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          hintText: 'Insert the subtask...',
                                          hintStyle: TextStyle(fontSize: 16, color: Color.fromARGB(255, 70, 69, 69)),
                                          contentPadding: EdgeInsets.only(top: 15),
                                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(0, 41, 41, 41))),
                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 99, 93, 69))),
                                        ),
                                        onTapOutside: (event) {
                                          focusList[index].unfocus();
                                        },
                                      ),
                                    ),
                                  ),
                      
                                  // Remove Icon
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    child: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          controllerList.remove(controllerList[index]);
                                          focusList.remove(focusList[index]);
                                          checkList.remove(checkList[index]);
                                        });
                                      },
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
        )
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
            controller.text = 'Empty task';
            tc.text = 'Empty task';
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

