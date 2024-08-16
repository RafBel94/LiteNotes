import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_write_app/presentation/screens/notes_screen.dart';
import 'package:read_write_app/presentation/screens/reminders_screen.dart';
import 'package:read_write_app/presentation/screens/providers/user_provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 254, 204, 54),
        centerTitle: true,
        title: Text(context.watch<UserProvider>().appBarTitle, style: const TextStyle(color: Colors.black),),
      ),

        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
              setAppBarTitle(index);
            });
          },
          selectedIndex: currentPageIndex,
          indicatorColor: Colors.amber,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Notes'
              ),
            NavigationDestination(
              icon: Icon(Icons.devices_other),
              label: 'Reminders'
              ),
          ],
          ),

      body: <Widget>[
        const NotesScreen(),
        RemindersScreen()][currentPageIndex
        ],
      
        floatingActionButton: currentPageIndex == 0 ? _NewNoteButton() : _NewReminderButton(),
      );
  }
  
// FUNCTIONS

  void setAppBarTitle(int index) {
    switch (index) {
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

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 50,
      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromARGB(164, 255, 193, 7))),
      icon: const Icon(Icons.note_add),
      onPressed: () {
        
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