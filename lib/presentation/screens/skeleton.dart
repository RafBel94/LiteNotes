import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/presentation/screens/new_note_screen.dart';
import 'package:simple_notes/presentation/screens/notes_screen.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/screens/reminders_screen.dart';
import 'package:simple_notes/presentation/screens/providers/user_provider.dart';

class Skeleton extends StatefulWidget {
  const Skeleton({super.key});

  @override
  State<StatefulWidget> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
    int currentPageIndex = 0;

    final UserProvider userProvider = UserProvider();
    

   @override
  Widget build(BuildContext context) {

    final NoteProvider noteProvider = context.watch<NoteProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 254, 204, 54),
        centerTitle: true,
        title: Text(context.watch<UserProvider>().appBarTitle, style: const TextStyle(color: Colors.black),),
      ),

        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int navigationIndex) {
            setState(() {
              currentPageIndex = navigationIndex;
              setAppBarTitle(navigationIndex);
            });
          },
          selectedIndex: currentPageIndex,
          indicatorColor: const Color.fromARGB(255, 117, 98, 48),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.description),
              label: 'Notes'
              ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month),
              label: 'Reminders'
              ),
          ],
          ),

      body: <Widget>[
        NotesScreen(noteProvider: noteProvider),
        RemindersScreen()][currentPageIndex
        ],
      
        floatingActionButton: currentPageIndex == 0 ? _NewNoteButton(noteProvider: noteProvider) : _NewReminderButton(),
      );
  }
  
// FUNCTIONS

  void setAppBarTitle(int currentPageIndex) {
    switch (currentPageIndex) {
      case 0:
        {
          context.read<UserProvider>().changeAppBarTitle(text: 'Notes');
        }
      case 1:
        {
          context.read<UserProvider>().changeAppBarTitle(text: 'Reminders');
        }
      default:
        {
          context.read<UserProvider>().changeAppBarTitle(text: 'App Default Title');
        }
    }
  }
}

// WIDGETS

class _NewNoteButton extends StatelessWidget {

  final NoteProvider noteProvider;

  const _NewNoteButton({required this.noteProvider});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 50,
      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 187, 140, 0))),
      icon: const Icon(Icons.note_add),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewNoteScreen(noteProvider: noteProvider)));
      },
    );
  }
}

class _NewReminderButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 50,
      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromARGB(164, 255, 193, 7))),
      icon: const Icon(Icons.event),
      onPressed: () {
        
      },
    );
  }
}