import 'package:flutter/material.dart';
import 'package:simple_notes/domain/entities/group.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:simple_notes/presentation/widgets/shared/modal_bottom_sheet.dart';
import 'package:simple_notes/presentation/widgets/shared/groups_scroll_view.dart';

import '../widgets/shared/title_text_field.dart';
import 'note_text_field.dart';

class UserNoteScreen extends StatefulWidget {
  final Note note;
  final TextEditingController titleController;
  final TextEditingController noteTextController;
  final NoteProvider noteProvider;

  UserNoteScreen({super.key, required this.noteProvider, required this.note})
      : titleController = TextEditingController(text: note.title),
        noteTextController = TextEditingController(text: note.text);

  @override
  State<StatefulWidget> createState() => _UserNoteScreenState();
}

class _UserNoteScreenState extends State<UserNoteScreen> {
  late String oldNoteText;
  late String oldNoteTitle;
  final GlobalKey<NoteGroupsScrollViewState> groupsScrollViewKey = GlobalKey<NoteGroupsScrollViewState>();

  @override
  // Initialize values with the state
  void initState() {
    super.initState();
    // Guarda los valores iniciales
    oldNoteText = widget.noteTextController.text.trim();
    oldNoteTitle = widget.titleController.text.trim();
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
        onPopInvokedWithResult: (bool didPop, context) {
          if (didPop) {
            compareAndUpdateNote(widget.titleController.text, widget.noteTextController.text, oldNoteTitle, oldNoteText, widget.noteProvider, groupsScrollViewKey.currentState?.getSelectedGroup());
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const BackButton(
              color: Colors.black,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.info),
                color: Colors.black,
                onPressed: () {
                  ModalBottomSheet(widget.note.modifiedDate, creationDate: widget.note.creationDate).showInfoMenu(context);
                },
              )
            ],
            backgroundColor: const Color.fromARGB(255, 254, 204, 54),
            centerTitle: true,
            title: Text(
              widget.note.title,
              style: const TextStyle(color: Colors.black),
            ),
          ),


          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                GroupsScrollView(key: groupsScrollViewKey, note: widget.note,),

                TitleTextField(
                  titleController: widget.titleController,
                ),

                const SizedBox(
                  height: 10,
                ),

                Expanded(
                    child: NoteTextField(
                  noteTextController: widget.noteTextController,
                )),
              ],
            ),
          ),


          floatingActionButton: IconButton(
            icon: const Icon(Icons.delete),
            style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 187, 140, 0))),
            iconSize: 50,
            onPressed: () {
              DeleteConfirmationDialog(context: context).showConfirmationDialog(context).then((confirmation) {
                if (confirmation == true) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  widget.noteProvider.removeNote(widget.note);
                }
              });
            },
          ),
        ));
  }

  void compareAndUpdateNote(String title, String text, String oldTitle, String oldText, NoteProvider noteProvider, Group? group) {
    String trimmedText = text.trim();
    String trimmedTitle = title.trim();

    Group? selectedGroup = groupsScrollViewKey.currentState?.getSelectedGroup();

    selectedGroup = selectedGroup ?? noteProvider.defaultGroup;

    if (trimmedText.isNotEmpty || trimmedTitle.isNotEmpty) {
      if (trimmedTitle.isEmpty) {
        trimmedTitle = 'No title';
      }

      widget.note.title = trimmedTitle;
      widget.note.text = text;

      if (oldTitle != trimmedTitle || oldText != trimmedText) {
        widget.note.modifiedDate = DateTime.now();
      }

      widget.note.group = selectedGroup;
      noteProvider.updateNote(widget.note);
    } else {
      noteProvider.removeNote(widget.note);
    }
  }

  
}