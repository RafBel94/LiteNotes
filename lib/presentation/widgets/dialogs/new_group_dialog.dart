import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/group.dart';
import 'package:simple_notes/presentation/screens/providers/group_provider.dart';
import 'package:simple_notes/presentation/widgets/shared/custom_color_picker.dart';

class NewGroupDialog {
  
  Future<dynamic> createGroupDialog(BuildContext context) {
    final GroupProvider groupProvider = context.read<GroupProvider>();
    final TextEditingController txtController = TextEditingController();
    Color selectedColor = Colors.cyan;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New group', style: TextStyle(fontSize: 30),),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          actions: [

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Group title:', style: TextStyle(fontSize: 22, color: Colors.white),)
            ),

            const SizedBox(height: 5,),

            TextField(
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: 'Insert group name...',
                hintStyle: const TextStyle(color: Color.fromARGB(255, 79, 79, 79)),
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.grey)
                )
              ),
              controller: txtController,
            ),

            const SizedBox(height: 15,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () async {
                    selectedColor = await CustomColorPicker().showColorPicker(context, selectedColor);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 239, 208, 115))),
                      child: const Text('SELECT COLOR',style: TextStyle(fontSize: 20, color: Colors.white),)
                    )
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(Icons.square_rounded, color: selectedColor, size: 40,),
                )
              ],
            ),

            const SizedBox(height: 15,),

            TextButton(
              onPressed: () {
                if (txtController.text.trim().isNotEmpty) {
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
                    }
                  );
                }
              },
              child: const Text('OK',style: TextStyle(fontSize: 20),)
            )
          ],
        );
      }
    );
  }
}