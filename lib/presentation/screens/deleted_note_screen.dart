import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/screens/providers/recicle_bin_provider.dart';
import 'package:simple_notes/presentation/widgets/dialogs/confirmation_dialog.dart';
import 'package:simple_notes/presentation/widgets/shared/note_info_bottom_sheet.dart';
import 'package:simple_notes/presentation/widgets/shared/note_text_field.dart';
import 'package:simple_notes/presentation/widgets/shared/title_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeletedNoteScreen extends StatefulWidget {
  final Note note;
  final TextEditingController titleController;
  final TextEditingController noteTextController;
  final RecicleBinProvider binProvider;

  DeletedNoteScreen({super.key, required this.binProvider, required this.note})
      : titleController = TextEditingController(text: note.title),
        noteTextController = TextEditingController(text: note.text);

  @override
  State<StatefulWidget> createState() => _DeletedNoteScreenState();
}

class _DeletedNoteScreenState extends State<DeletedNoteScreen> {

  @override
  Widget build(BuildContext context) {

    final NoteProvider noteProvider = context.read<NoteProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.black, size: 30),
            onPressed: () {
              ConfirmationDialog(context: context, message: AppLocalizations.of(context)!.confirmation_dialog_delete_note).showConfirmationDialog(context).then((confirmation) {
                if (confirmation == true) {
                  widget.binProvider.removeNote(widget.note);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              });
            }),

            IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black, size: 30),
            onPressed: () {
              ConfirmationDialog(context: context, message: AppLocalizations.of(context)!.confirmation_dialog_recover_note).showConfirmationDialog(context).then((confirmation) {
                if (confirmation == true) {
                  widget.note.deletedDate = null;
                  noteProvider.addNote(widget.note);
                  widget.binProvider.removeNote(widget.note);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              });
            }),
    
          IconButton(
            icon: const Icon(Icons.info),
            color: Colors.black,
            onPressed: () {
              NoteInfoBottomSheet(widget.note.modifiedDate, creationDate: widget.note.creationDate, deletedDate: widget.note.deletedDate).showInfoMenu(context);
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
    
    
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 15, 15, 15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
        
              TitleTextField(titleController: widget.titleController, isEnabled: false),
        
              const SizedBox(height: 10,),
        
              Expanded(child: NoteTextField(
                noteTextController: widget.noteTextController,
                isEnabled: false,
                )
              ),
            ],
          ),
        ),
      )
    );
  }
}