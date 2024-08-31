import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/task.dart';
import 'package:simple_notes/domain/entities/task_check.dart';
import 'package:simple_notes/presentation/screens/providers/task_provider.dart';
import 'package:simple_notes/presentation/widgets/shared/title_text_field.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  TextEditingController titleController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<TaskCheck> checkList = [];
  List<TextEditingController> controllerList = [];
  List<FocusNode> focusList = [];

  @override
  void dispose() {

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

  TaskProvider taskProvider = context.read<TaskProvider>();

    return PopScope(
      onPopInvokedWithResult: (bool didPop, result) {
        if(didPop){
          verifyTask(taskProvider);
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
                icon: const Icon(Icons.check, color: Colors.black, size: 30,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),

          body: Container(
            decoration: const BoxDecoration(color: Color.fromARGB(255, 24, 24, 24)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 5),

                  TitleTextField(titleController: titleController),

                  Container(margin: const EdgeInsets.only(top: 15, bottom: 10), child: const Text('Checklist', style: TextStyle(fontSize: 20))),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        // Here instead of using a ListView.builder, we use a SingleChildScrollView so we can scroll through
                        // all the task checks, and in this column, instead of creating the widgets manually, we do it throug
                        // a List.generate that use the length of the checkList from the provider
                        children: List.generate(checkList.length, (index) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: checkList[index].done ? const Icon(Icons.check_box_outlined, color: Color.fromARGB(255, 81, 81, 81)) : const Icon(Icons.check_box_outline_blank_outlined, color: Color.fromARGB(255, 165, 145, 86),),
                                  onPressed: () {
                                    setState(() {
                                      checkList[index].done = !checkList[index].done;
                                    });
                                  },
                                ),

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
                                        hintText: 'Insert the check text...',
                                        hintStyle: TextStyle(fontSize: 16, color: Color.fromARGB(255, 70, 69, 69)),
                                        contentPadding: EdgeInsets.only(top: 15),
                                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(0, 41, 41, 41))),
                                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 99, 93, 69))),
                                      ),
                                      onTapOutside: (event) {
                                        FocusScope.of(context).unfocus();
                                      },
                                    ),
                                  ),
                                ),

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

                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color.fromARGB(255, 87, 76, 45)),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: TextButton.icon(
                        label: const Text('Add check',
                        style: TextStyle(fontSize: 18, color: Colors.white),),
                        icon: const Icon(Icons.add_box_outlined),
                        onPressed: () {
                          setState(() {
                            _addNewCheck();
                          });
                        }
                      ),
                    )
                  ),

                  const SizedBox(height: 15,)
                ],
              ),
            ),
          ),
        )
    );
  }
  
  void _addNewCheck() {
    setState(() {
      TextEditingController controller = TextEditingController();
      FocusNode focusNode = FocusNode();
      TaskCheck taskCheck = TaskCheck.create('', false);

      controllerList.add(controller);
      focusList.add(focusNode);
      checkList.add(taskCheck);

      focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        setState(() {
          if (controller.text.trim().isEmpty) {
            controller.text = 'No text';
            taskCheck.text = 'No text';
          } else {
            taskCheck.text = controller.text;
          }
        });
      }
    });

      // Request focus for the new TextField
      Future.delayed(const Duration(milliseconds: 100), () {
        // ignore: use_build_context_synchronously
        FocusScope.of(context).requestFocus(focusNode);
      });
    });
  }
  
  void verifyTask(TaskProvider taskProvider) {
    String trimmedTitle = titleController.text.trim();
    Task task = Task.create(title: titleController.text, checkList: checkList);

    if(trimmedTitle.isEmpty){
      task.title = 'No title task';
    }

    taskProvider.addTask(task);
  }
}

