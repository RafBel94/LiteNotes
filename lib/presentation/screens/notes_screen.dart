import 'package:flutter/material.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/screens/user_note_screen.dart';
import 'package:simple_notes/presentation/widgets/shared/delete_confirmation_dialog.dart';

class NotesScreen extends StatelessWidget {
  final NoteProvider noteProvider;

  const NotesScreen({
    super.key,
    required this.noteProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromARGB(255, 24, 24, 24)),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
          itemCount: noteProvider.noteList.length,
          itemBuilder: (context, index) {
            final Note note = noteProvider.noteList[index];

            return _NoteButton(
              note: note,
              noteProvider: noteProvider,
            );
          },
        ),
      ),
    );
  }
}

class _NoteButton extends StatelessWidget {
  final Note note;
  final NoteProvider noteProvider;

  const _NoteButton({required this.note, required this.noteProvider});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), backgroundColor: const WidgetStatePropertyAll(Color.fromARGB(25, 158, 158, 158))),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserNoteScreen(
                        note: note,
                        noteProvider: noteProvider,
                      )));
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
        ));
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
                  getDeleteConfirmation(context).then((confirmation) {
                    if (confirmation == true) {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      noteProvider.removeNote(note);
                    }
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool?> getDeleteConfirmation(BuildContext context) async {
    bool? result = await DeleteConfirmationDialog(context: context).showConfirmationDialog(context);

    return result ?? false;
  }
}