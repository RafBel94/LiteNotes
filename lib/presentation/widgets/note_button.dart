import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/presentation/screens/deleted_note_screen.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/screens/providers/recicle_bin_provider.dart';
import 'package:simple_notes/presentation/screens/user_note_screen.dart';
import 'package:simple_notes/presentation/widgets/dialogs/confirmation_dialog.dart';
import 'package:simple_notes/presentation/widgets/dialogs/remove_group_dialog.dart';

class NoteButton extends StatelessWidget {
  final Note note;
  final bool isDeleted;
  final bool isMultiSelectMode;
  final bool isSelected;
  final VoidCallback onLongPress;
  final VoidCallback onSelected;

  const NoteButton({
    super.key,
    required this.note,
    required this.isDeleted,
    required this.isMultiSelectMode,
    required this.isSelected,
    required this.onLongPress,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final RecicleBinProvider binProvider = context.read<RecicleBinProvider>();
    final NoteProvider noteProvider = context.read<NoteProvider>();

    return GestureDetector(
      onLongPress: onLongPress,
      child: Stack(
        children: [
          SizedBox.expand(
            child: TextButton(
              style: TextButton.styleFrom(
                side: BorderSide(
                  color: (note.group != null && !isDeleted)
                      ? note.group!.color
                      : Colors.transparent,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color.fromARGB(25, 158, 158, 158),
              ),
              onPressed: () {
                if (!isDeleted && !isMultiSelectMode) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserNoteScreen(
                        note: note,
                        noteProvider: noteProvider,
                      ),
                    ),
                  );
                } else if (isMultiSelectMode) {
                  onSelected();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeletedNoteScreen(
                        note: note,
                        binProvider: binProvider,
                      ),
                    ),
                  );
                }
              },
              child: Column(
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 242, 221, 159),
                    ),
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
                  ),
                ],
              ),
            ),
          ),
          if (isMultiSelectMode)
            Positioned(
              top: 8,
              right: 8,
              child: Radio(
                groupValue: true,
                toggleable: true,
                value: isSelected,
                onChanged: (value) {
                  onSelected();
                },
              ),
            ),
        ],
      ),
    );
  }

  // showLongPressMenu(BuildContext context, RecicleBinProvider binProvider, NoteProvider noteProvider) {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     builder: (context) {
  //       return Container(
  //         padding: const EdgeInsets.symmetric(vertical: 15),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             IconButton(
  //               icon: const Icon(Icons.edit),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => UserNoteScreen(
  //                       note: note,
  //                       noteProvider: noteProvider,
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //             IconButton(
  //               icon: const Icon(Icons.delete),
  //               onPressed: () async {
  //                 ConfirmationDialog(
  //                   context: context,
  //                   message: 'Do you really want to delete this note?',
  //                 ).showConfirmationDialog(context).then((confirmation) {
  //                   if (confirmation == true) {
  //                     binProvider.addNote(note);
  //                     noteProvider.removeNote(note);
  //                     Navigator.pop(context);
  //                   }
  //                 });
  //               },
  //             ),
  //             if (note.group != noteProvider.defaultGroup)
  //               IconButton(
  //                 icon: const Icon(Icons.group_remove_rounded),
  //                 onPressed: () async {
  //                   final confirmation = await RemoveGroupDialog(context: context)
  //                       .showConfirmationDialog(context);
  //                   if (confirmation == true) {
  //                     note.group = noteProvider.defaultGroup;
  //                     noteProvider.updateNote(note);
  //                     Navigator.pop(context);
  //                   }
  //                 },
  //               ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
