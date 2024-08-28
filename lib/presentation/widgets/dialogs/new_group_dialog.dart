import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/group.dart';
import 'package:simple_notes/presentation/screens/providers/group_provider.dart';
import 'package:simple_notes/presentation/widgets/shared/custom_color_picker.dart';

class NewGroupDialog {
  
  Future<dynamic> createGroupDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          GroupProvider groupProvider = context.read<GroupProvider>();
          final TextEditingController txtController = TextEditingController();
          Color selectedColor = Colors.cyan;

          return AlertDialog(
            title: const Text('Insert new group name:'),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            actions: [

              
              TextField(
                style: const TextStyle(fontSize: 20),
                controller: txtController,
              ),
              const SizedBox(
                height: 15,
              ),


              Align(
                  alignment: Alignment.center,
                  child: TextButton(
                      onPressed: () async {
                        selectedColor = await CustomColorPicker().showColorPicker(context, selectedColor);
                      },
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 239, 208, 115))),
                          child: const Text(
                            'SELECT COLOR',
                            style: TextStyle(fontSize: 20),
                          )))),
              const SizedBox(
                height: 15,
              ),


              TextButton(
                  onPressed: () {
                    if(txtController.value.text.trim().isNotEmpty){
                      groupProvider.addGroup(Group.create(name: txtController.value.text, color: selectedColor));
                      Navigator.of(context).pop();
                    }else{
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Warning', style: TextStyle(color: Color.fromARGB(255, 249, 208, 86))),
                              content: const Text('The group name cannot be empty', style: TextStyle(fontSize: 20)),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK', style: TextStyle(fontSize: 20))
                                )
                              ],
                            );
                          });
                    }
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          );
        });
  }
}