import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/group.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/presentation/screens/note_text_field.dart';
import 'package:simple_notes/presentation/screens/providers/group_provider.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/widgets/shared/groups_scroll_view.dart';
import 'package:simple_notes/presentation/widgets/shared/title_text_field.dart';

class NewNoteScreen extends StatefulWidget {

  const NewNoteScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteTextController = TextEditingController();
  final GlobalKey<NoteGroupsScrollViewState> groupsScrollViewKey = GlobalKey<NoteGroupsScrollViewState>();

  @override
  Widget build(BuildContext context) {

    final NoteProvider noteProvider = context.read<NoteProvider>();
    final GroupProvider groupProvider = context.read<GroupProvider>();

    return PopScope(
        onPopInvokedWithResult: (bool didPop, context) {
          if (didPop) {
            addNote(titleController.text, noteTextController.text, noteProvider);
          }
        },

        child: Scaffold(
          appBar: AppBar(
            leading: const BackButton(
              color: Colors.black,
            ),
            backgroundColor: const Color.fromARGB(255, 254, 204, 54),
            centerTitle: true,
            title: const Text(
              'New Note',
              style: TextStyle(color: Colors.black),
            ),
          ),


          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if(groupProvider.groupList.isNotEmpty)
                  GroupsScrollView(key: groupsScrollViewKey),
                
                TitleTextField(titleController: titleController),

                const SizedBox(
                  height: 10,
                ),

                Expanded(child: NoteTextField(noteTextController: noteTextController)),
              ],
            ),
          ),
        ));
  }

  void addNote(String title, String text, NoteProvider noteProvider) {
    String trimmedTitle = title.trim();
    String trimmedText = text.trim();

    Group? selectedGroup = groupsScrollViewKey.currentState?.getSelectedGroup();

    selectedGroup = selectedGroup ?? noteProvider.defaultGroup;

    if (trimmedText.isNotEmpty) {
      if (trimmedTitle.isEmpty) {
        trimmedTitle = 'No Title';
      }

      Note note = Note.create(title: trimmedTitle, text: text, group: selectedGroup);
      noteProvider.addNote(note);
    } else if (trimmedText.isEmpty && trimmedTitle.isNotEmpty) {
      Note note = Note.create(title: trimmedTitle, text: text, group: selectedGroup);
      noteProvider.addNote(note);
    }
  }
}
