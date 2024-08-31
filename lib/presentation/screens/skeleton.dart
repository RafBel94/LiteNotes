import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/presentation/screens/new_note_screen.dart';
import 'package:simple_notes/presentation/screens/new_task_screen.dart';
import 'package:simple_notes/presentation/screens/notes_screen.dart';
import 'package:simple_notes/presentation/screens/providers/group_provider.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/screens/providers/task_provider.dart';
import 'package:simple_notes/presentation/screens/tasks_screen.dart';
import 'package:simple_notes/presentation/widgets/sort_button.dart';
import 'package:simple_notes/presentation/widgets/shared/app_drawer.dart';

class Skeleton extends StatefulWidget {
  const Skeleton({super.key});

  @override
  State<StatefulWidget> createState() => SkeletonState();
}

class SkeletonState extends State<Skeleton> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<ProviderType>(context, listen: false) is the same as context.read<ProviderType>();
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      final groupProvider = Provider.of<GroupProvider>(context, listen: false);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      // Inicializar NoteProvider con GroupProvider
      noteProvider.initialize(groupProvider);

      // Inicializar TaskProvider
      taskProvider.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final NoteProvider noteProvider = context.watch<NoteProvider>();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 23, 23, 23),
      appBar: AppBar(
        actions: [
          if(noteProvider.filteredGroup != noteProvider.defaultGroup)
            IconButton(
              onPressed: (){
                noteProvider.updateFilteredGroup(null);
              },
              icon: const Icon(Icons.filter_alt_off, color: Colors.black, size: 30,)
            ),

          const SortButton()
        ],
        backgroundColor: const Color.fromARGB(255, 254, 204, 54),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          currentPageIndex == 0 ? 'Notes' : 'Tasks',
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
          NavigationDestination(icon: Icon(Icons.checklist_sharp), label: 'Tasks'),
        ],
      ),

      drawer: const AppDrawer(),

      body: <Widget>[const NotesScreen(), const TasksScreen()][currentPageIndex],

      floatingActionButton: currentPageIndex == 0 ? const _NewNoteButton() : _NewTaskButton(),
    );
  }
}



// WIDGETS

class _NewNoteButton extends StatelessWidget {

  const _NewNoteButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 50,
      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 187, 140, 0))),
      icon: const Icon(Icons.note_add),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewNoteScreen()));
      },
    );
  }
}

class _NewTaskButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 50,
      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromARGB(164, 255, 193, 7))),
      icon: const Icon(Icons.add_box_outlined),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewTaskScreen()));
      },
    );
  }
}
