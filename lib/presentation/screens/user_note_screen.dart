
import 'package:flutter/material.dart';
import 'package:read_write_app/domain/entities/note.dart';
import 'package:read_write_app/presentation/screens/providers/note_provider.dart';

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


  @override
  Widget build(BuildContext context) {

    return PopScope(
      onPopInvoked: (bool didPop) {
        if(didPop){
          updateNote(widget.titleController.text, widget.noteTextController.text, widget.noteProvider);

        }
      },
      child: Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {

            updateNote(widget.titleController.text, widget.noteTextController.text, widget.noteProvider);
            
            Navigator.pop(context);
          }
        ),
        backgroundColor: const Color.fromARGB(255, 254, 204, 54),
        centerTitle: true,
        title: Text(widget.note.title, style: const TextStyle(color: Colors.black),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [

            _TitleTextField(titleController: widget.titleController,),


            const Divider(
              color: Color.fromARGB(203, 249, 212, 102),
              indent: 5,
              endIndent: 5,
            ),

            Expanded(child: _NoteTextField(noteTextController: widget.noteTextController,)),
          ],
        ),
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.delete),
        style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromARGB(164, 255, 193, 7))),
        iconSize: 50,
        onPressed: () {
          widget.noteProvider.removeNote(widget.note);
          Navigator.pop(context);
        },
      ),
    ));
  }
  
  void updateNote(String title, String text, NoteProvider noteProvider) {
    String trimmedText = text.trim();
    String trimmedTitle = title.trim();

    if (trimmedText.isNotEmpty || trimmedTitle.isNotEmpty) {
      if (trimmedTitle.isEmpty) {
        trimmedTitle = 'No title';
      }

      widget.note.title = trimmedTitle;
      widget.note.text = text;
      noteProvider.updateNote(widget.note);
    } else {
      noteProvider.removeNote(widget.note);
    }
  }
}


class _TitleTextField extends StatelessWidget {

  final TextEditingController titleController;
  final FocusNode titleFocusNode = FocusNode();

   _TitleTextField({required this.titleController});  // Aquí se inicializa el controlador con el título

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: titleController,
      focusNode: titleFocusNode,
      style: const TextStyle(fontSize: 22),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: 'Title',
        hintStyle: const TextStyle(fontSize: 18)
      ),
      
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

