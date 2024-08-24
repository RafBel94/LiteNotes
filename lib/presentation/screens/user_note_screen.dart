import 'package:flutter/material.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/widgets/shared/delete_confirmation_dialog.dart';

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

  @override
  // Initialize values with the state
  void initState() {
    super.initState();
    // Guarda los valores iniciales
    oldNoteText = widget.noteTextController.text.trim();
    oldNoteTitle = widget.titleController.text.trim();
  }

  @override
  // Things to do when app closes
  void dispose() {
    compareAndUpdateNote(
      widget.titleController.text,
      widget.noteTextController.text,
      oldNoteTitle,
      oldNoteText,
      widget.noteProvider,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvokedWithResult: (bool didPop, context) {
          if (didPop) {
            compareAndUpdateNote(widget.titleController.text, widget.noteTextController.text, oldNoteTitle, oldNoteText, widget.noteProvider);
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
                  showInfoMenu(context);
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
                _TitleTextField(
                  titleController: widget.titleController,
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: _NoteTextField(
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
              getDeleteConfirmation().then((confirmation) {
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

  Future<bool?> getDeleteConfirmation() async {
    bool? result = await DeleteConfirmationDialog(context: context).showConfirmationDialog(context);

    return result ?? false;
  }

  void compareAndUpdateNote(String title, String text, String oldTitle, String oldText, NoteProvider noteProvider) {
    String trimmedText = text.trim();
    String trimmedTitle = title.trim();

    if (trimmedText.isNotEmpty || trimmedTitle.isNotEmpty) {
      if (trimmedTitle.isEmpty) {
        trimmedTitle = 'No title';
      }

      widget.note.title = trimmedTitle;
      widget.note.text = text;

      if (oldTitle != trimmedTitle || oldText != trimmedText) {
        widget.note.modifiedDate = DateTime.now();
      }

      noteProvider.updateNote(widget.note);
    } else {
      noteProvider.removeNote(widget.note);
    }
  }

  void showInfoMenu(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (context) {
        return SizedBox(
            width: size.width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Creation date:   ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      TextSpan(text: widget.note.creationDate.toString().split('.').first, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Modified date:   ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      TextSpan(text: widget.note.modifiedDate.toString().split('.').first, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ));
      },
    );
  }
}

class _TitleTextField extends StatelessWidget {
  final TextEditingController titleController;
  final FocusNode titleFocusNode = FocusNode();

  _TitleTextField({required this.titleController}); // Aquí se inicializa el controlador con el título

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
  final TextEditingController noteTextController;
  final FocusNode noteTextFocusNode = FocusNode();

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
