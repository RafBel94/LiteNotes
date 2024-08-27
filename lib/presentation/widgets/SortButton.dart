import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';

class SortButton extends StatefulWidget {
  const SortButton({
    super.key,
  });
  
  @override
  SortButtonState createState() => SortButtonState();
}

class SortButtonState extends State<SortButton> {
  bool isMenuOpen = false;
  // final GlobalKey<NotesScreenState> notesScreenKey = GlobalKey<NotesScreenState>();

  @override
  Widget build(BuildContext context) {

    NoteProvider noteProvider = context.read<NoteProvider>();

    return PopupMenuButton<int>(
      onOpened: () {
        setState(() {
          isMenuOpen = true;
        });
      },
      onCanceled: () {
        setState(() {
          isMenuOpen = false;
        });
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          isMenuOpen ? const Color.fromARGB(255, 139, 115, 49) : Colors.transparent,
        ),
      ),
      offset: const Offset(0, 53),
      icon: const Icon(Icons.filter_list, size: 30),
      onSelected: (int selected) {
        switch(selected) {
          case 1: {
            noteProvider.sortListAlphabetically(descendent: true);
            break;
          }
          case 2: {
            noteProvider.sortListAlphabetically(descendent: false);
            break;
          }
          case 3: {
            noteProvider.sortListByModifiedDate(recentFirst: true);
            break;
          }
          case 4: {
            noteProvider.sortListByModifiedDate(recentFirst: false);
            break;
          }
        }
        setState(() {
          isMenuOpen = false;
        });
      },
      itemBuilder: (context) {
        return <PopupMenuEntry<int>>[
          const PopupMenuItem(
            value: 1,
            child: Text('Sort alphabetically (A-Z)'),
          ),
          const PopupMenuItem(
            value: 2,
            child: Text('Sort alphabetically (Z-A)'),
          ),
          const PopupMenuItem(
            value: 3,
            child: Text('Sort by last modified (Recent)'),
          ),
          const PopupMenuItem(
            value: 4,
            child: Text('Sort by last modified (Older)'),
          ),
        ];
      },
    );
  }
}