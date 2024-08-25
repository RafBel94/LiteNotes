import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/presentation/screens/providers/group_provider.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/widgets/shared/note_groups_scroll_view.dart';

class NewNoteScreen extends StatefulWidget {
  final NoteProvider noteProvider;

  const NewNoteScreen({super.key, required this.noteProvider});

  @override
  State<StatefulWidget> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final GroupProvider groupProvider = context.read<GroupProvider>();

    return PopScope(
        onPopInvokedWithResult: (bool didPop, context) {
          if (didPop) {
            addNote(titleController.text, noteTextController.text, widget.noteProvider);
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
                groupProvider.groupList.isNotEmpty ? const NoteGroupsScrollView() : SizedBox.shrink(),
                
                _TitleTextField(titleController: titleController),
                const SizedBox(
                  height: 10,
                ),
                Expanded(child: _NoteTextField(noteTextController: noteTextController)),
              ],
            ),
          ),
        ));
  }

  void addNote(String title, String text, NoteProvider noteProvider) {
    String trimmedTitle = title.trim();
    String trimmedText = text.trim();

    if (trimmedText.isNotEmpty) {
      if (trimmedTitle.isEmpty) {
        trimmedTitle = 'No Title';
      }

      Note note = Note.create(title: trimmedTitle, text: text);
      noteProvider.addNote(note);
    } else if (trimmedText.isEmpty && trimmedTitle.isNotEmpty) {
      Note note = Note.create(title: trimmedTitle, text: text);
      noteProvider.addNote(note);
    }
  }
}

class _TitleTextField extends StatelessWidget {
  final FocusNode titleFocusNode = FocusNode();
  final TextEditingController titleController;

  _TitleTextField({required this.titleController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: titleController,
      focusNode: titleFocusNode,
      style: const TextStyle(fontSize: 22),
      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), hintText: 'Title', hintStyle: const TextStyle(fontSize: 18)),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}

class _NoteTextField extends StatelessWidget {
  final FocusNode noteTextFocusNode = FocusNode();
  final TextEditingController noteTextController;

  _NoteTextField({required this.noteTextController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: noteTextController,
      focusNode: noteTextFocusNode,
      maxLines: null,
      expands: true,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.top,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: 'Text...',
        hintStyle: const TextStyle(fontSize: 18),
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
