import 'package:flutter/material.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/screens/user_note_screen.dart';
import 'package:simple_notes/presentation/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:simple_notes/presentation/widgets/dialogs/remove_group_dialog.dart';

class NoteButton extends StatelessWidget {
  final Note note;
  final NoteProvider noteProvider;

  const NoteButton({super.key, required this.note, required this.noteProvider});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        side: BorderSide(color: note.group != null ? note.group!.color : Colors.transparent),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color.fromARGB(25, 158, 158, 158)
      ),
      onPressed: () {
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => UserNoteScreen(
              note: note,
              noteProvider: noteProvider,
            )
          )
        );
      },
      onLongPress: () {
        showLongPressMenu(context);
      },
      child: Column(
        children: [
          Text(
            note.title,
            style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 242, 221, 159)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(
            child: Text(
              note.text,
              style: const TextStyle(fontSize: 15, color: Colors.white),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      )
    );
  }

  showLongPressMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserNoteScreen(
                                note: note,
                                noteProvider: noteProvider,
                              )));
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  DeleteConfirmationDialog(context: context).showConfirmationDialog(context).then((confirmation) {
                    if (confirmation == true) {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      noteProvider.removeNote(note);
                    }
                  });
                },
              ),
              if (note.group != noteProvider.defaultGroup)
                IconButton(
                  icon: const Icon(Icons.group_remove_rounded),
                  onPressed: () async {
                    final confirmation = await RemoveGroupDialog(context: context).showConfirmationDialog(context);
                    if (confirmation == true) {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      note.group = noteProvider.defaultGroup;
                      noteProvider.updateNote(note);
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}