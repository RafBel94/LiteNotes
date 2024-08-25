import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/group.dart';
import 'package:simple_notes/presentation/screens/new_note_screen.dart';
import 'package:simple_notes/presentation/screens/notes_screen.dart';
import 'package:simple_notes/presentation/screens/providers/group_provider.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/screens/reminders_screen.dart';

class Skeleton extends StatefulWidget {
  const Skeleton({super.key});

  @override
  State<StatefulWidget> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final NoteProvider noteProvider = context.watch<NoteProvider>();

    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 254, 204, 54),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(
            currentPageIndex == 0 ? 'Notes' : 'Reminders',
            style: const TextStyle(color: Colors.black),
          )),

      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int navigationIndex) {
          setState(() {
            currentPageIndex = navigationIndex;
          });
        },
        selectedIndex: currentPageIndex,
        indicatorColor: const Color.fromARGB(255, 117, 98, 48),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.description), label: 'Notes'),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Reminders'),
        ],
      ),

      drawer: _AppDrawer(),

      body: <Widget>[NotesScreen(noteProvider: noteProvider), const RemindersScreen()][currentPageIndex],
      floatingActionButton: currentPageIndex == 0 ? _NewNoteButton(noteProvider: noteProvider) : _NewReminderButton(),
    );
  }
}

// WIDGETS

class _AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GroupProvider groupProvider = context.watch<GroupProvider>();

    return Drawer(
      elevation: 40,
      shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[

          Container(
            height: 80,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 254, 204, 54),
            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),

          ExpansionTile(
            title: const Text('Groups'),
            backgroundColor: const Color.fromARGB(255, 42, 38, 29),
            leading: const Icon(Icons.account_tree),
            children: <Widget>[
              Consumer<GroupProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.groupList.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style: const ButtonStyle(overlayColor: WidgetStatePropertyAll(Colors.transparent)),
                              child: Text(
                                provider.groupList[index].name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 16, color: Colors.white),
                              ),
                              onPressed: () {
                                // Acción al presionar el botón
                              },
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              groupProvider.removeGroupByName(provider.groupList[index].name);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

              Container(
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color.fromARGB(255, 138, 115, 50))
                ),
                child: ListTile(
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      Text('  New group', style: TextStyle(color: Colors.white, fontSize: 17),)
                    ],
                  ),
                  onTap: () {
                    groupProvider.addGroup(Group.create(name: 'Test', color: Colors.cyan));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
      onPressed: () {},
    );
  }
}
