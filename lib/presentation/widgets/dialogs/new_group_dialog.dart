import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/group.dart';
import 'package:simple_notes/presentation/screens/providers/group_provider.dart';
import 'package:simple_notes/presentation/widgets/shared/custom_color_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewGroupDialog {
  
  Future<dynamic> createGroupDialog(BuildContext context) {
    final GroupProvider groupProvider = context.read<GroupProvider>();
    final TextEditingController txtController = TextEditingController();
    Color selectedColor = Colors.cyan;

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState){
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.dialog_new_group_title, style: const TextStyle(fontSize: 30),),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: const Color.fromARGB(255, 30, 30, 27),
            actions: [
          
              Align(
                alignment: Alignment.centerLeft,
                child: Text(AppLocalizations.of(context)!.dialog_new_group_group_title_text, style: const TextStyle(fontSize: 22, color: Colors.white),)
              ),
          
              const SizedBox(height: 5,),
          
              TextField(
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.dialog_new_group_title_textfield_hint,
                  hintStyle: const TextStyle(color: Color.fromARGB(255, 79, 79, 79)),
                  contentPadding: const EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.grey)
                  )
                ),
                controller: txtController,
              ),
          
              const SizedBox(height: 20,),
          
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero
                    ),
                    onPressed: () async {
                      Color newColor = await CustomColorPicker().showColorPicker(context, selectedColor);
                      setState(() {
                        selectedColor = newColor;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 239, 208, 115))),
                      child: Text(AppLocalizations.of(context)!.select_color_button,style: const TextStyle(fontSize: 20, color: Colors.white),)
                    )
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.square_rounded,
                        color: selectedColor,
                        size: 40,
                      ),
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
                          title: Text(AppLocalizations.of(context)!.warning, style: const TextStyle(color: Color.fromARGB(255, 249, 208, 86))),
                          content: Text(AppLocalizations.of(context)!.empty_group_name, style: const TextStyle(fontSize: 20)),
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
    );
  }
}