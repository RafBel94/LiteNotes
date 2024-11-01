import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/group.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/presentation/screens/providers/group_provider.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/widgets/shared/custom_color_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditGroupDialog {
  
  Future<dynamic> editGroup(BuildContext context, Group group) {
    final GroupProvider groupProvider = context.read<GroupProvider>();
    final NoteProvider noteProvider = context.read<NoteProvider>();
    final TextEditingController txtController = TextEditingController(text: group.name);
    Color selectedColor = group.color;

    return showDialog(context: context, builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.dialog_edit_group_title, style: const TextStyle(fontSize: 30)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: const Color.fromARGB(255, 30, 30, 27),
              actions: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.dialog_new_group_group_title_text,
                    style: const TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.dialog_new_group_title_textfield_hint,
                    hintStyle: const TextStyle(color: Color.fromARGB(255, 79, 79, 79)),
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  controller: txtController,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () async {
                        final newColor = await CustomColorPicker().showColorPicker(context, selectedColor);
                        setState(() {
                          selectedColor = newColor;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(255, 239, 208, 115))),
                        child: Text(
                          AppLocalizations.of(context)!.select_color_button,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
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
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    if (txtController.text.trim().isNotEmpty) {
                      updateNotesGroups(
                          group: group,
                          selectedColor: selectedColor,
                          txtController: txtController,
                          groupProvider: groupProvider,
                          noteProvider: noteProvider);
                      Navigator.of(context).pop();
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(AppLocalizations.of(context)!.warning,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 249, 208, 86))),
                              content: Text(
                                  AppLocalizations.of(context)!.empty_group_name,
                                  style: const TextStyle(fontSize: 20)),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(fontSize: 20),
                                    ))
                              ],
                            );
                          });
                    }
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
  
  void updateNotesGroups({
    required Group group,
    required Color selectedColor,
    required TextEditingController txtController,
    required GroupProvider groupProvider,
    required NoteProvider noteProvider,
  }) {
    group.color = selectedColor;
    group.name = txtController.text.trim();
    groupProvider.updateGroup(group);

    for (Note n in noteProvider.noteList.where((n) => n.group == group)) {
      n.group?.color = group.color;
      n.group?.name = group.name;
      noteProvider.updateNote(n);
    }
  }
}
