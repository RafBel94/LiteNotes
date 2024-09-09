import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_notes/presentation/screens/notes/new_note_screen.dart';
import 'package:simple_notes/presentation/screens/tasks/new_task_screen.dart';
import 'package:simple_notes/presentation/screens/notes/notes_screen.dart';
import 'package:simple_notes/presentation/screens/providers/group_provider.dart';
import 'package:simple_notes/presentation/screens/providers/multiselect_provider.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/screens/providers/recicle_bin_provider.dart';
import 'package:simple_notes/presentation/screens/providers/task_provider.dart';
import 'package:simple_notes/presentation/screens/tasks/tasks_screen.dart';
import 'package:simple_notes/presentation/widgets/dialogs/confirmation_dialog.dart';
import 'package:simple_notes/presentation/widgets/shared/buttons/multi_delete_button.dart';
import 'package:simple_notes/presentation/widgets/shared/buttons/multiselection_cancel_button.dart';
import 'package:simple_notes/presentation/widgets/shared/buttons/sort_button.dart';
import 'package:simple_notes/presentation/widgets/shared/app_drawer.dart';

class MainScaffold extends StatefulWidget {
  final Function(Locale) onLanguageChanged;
  const MainScaffold({super.key, required this.onLanguageChanged});

  @override
  State<StatefulWidget> createState() => MainScaffoldState();
}

class MainScaffoldState extends State<MainScaffold> {
  int currentPageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: currentPageIndex);

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
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NoteProvider noteProvider = context.watch<NoteProvider>();
    final TaskProvider taskProvider = context.watch<TaskProvider>();
    final MultiselectProvider multiselectProvider = context.watch<MultiselectProvider>();
    final RecicleBinProvider recicleBinProvider = context.read<RecicleBinProvider>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 23, 23),
      appBar: AppBar(
        actions: [
          if (multiselectProvider.isNotesMultiSelectMode) ...[
              MultiselectionCancelButton(multiselectProvider: multiselectProvider, type: 'note'),
              MultiDeleteButton(onDelete: () => deleteSelectedNotes(noteProvider, multiselectProvider, recicleBinProvider))
            ],

          if (multiselectProvider.isTasksMultiSelectMode) ...[
              MultiselectionCancelButton(multiselectProvider: multiselectProvider, type: 'task'),
              MultiDeleteButton(onDelete: () => deleteSelectedTasks(taskProvider, multiselectProvider, recicleBinProvider))
            ],
          
          if(noteProvider.filteredGroup != noteProvider.defaultGroup)
            IconButton(
              onPressed: (){
                noteProvider.updateFilteredGroup(null);
              },
              icon: const Icon(Icons.filter_alt_off, color: Colors.black, size: 30,)
            ),

          const SortButton(isDeletedScreen: false,)
        ],
        backgroundColor: const Color.fromARGB(255, 254, 204, 54),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          currentPageIndex == 0 ? AppLocalizations.of(context)!.skeleton_notes_screen_title : AppLocalizations.of(context)!.skeleton_tasks_screen_title,
          style: const TextStyle(color: Colors.black),
        )),
        
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: onNavigationItemSelected,
        selectedIndex: currentPageIndex,
        indicatorColor: const Color.fromARGB(255, 117, 98, 48),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.description), label: AppLocalizations.of(context)!.navigation_bar_notes),
          NavigationDestination(icon: const Icon(Icons.checklist_sharp), label: AppLocalizations.of(context)!.navigation_bar_tasks),
        ],
      ),

      drawer: AppDrawer(onLanguageChanged: widget.onLanguageChanged, multiselectProvider: multiselectProvider,),

      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: const [
          NotesScreen(),
          TasksScreen(),
        ],
      ),

      floatingActionButton: currentPageIndex == 0 ? const _NewNoteButton() : _NewTaskButton(),
    );
  }

  void onPageChanged(int pageIndex) {
    setState(() {
      currentPageIndex = pageIndex;
    });
  }

  void onNavigationItemSelected(int navigationIndex) {
    setState(() {
      if (context.read<MultiselectProvider>().isNotesMultiSelectMode) {
        context.read<MultiselectProvider>().toggleNotesMultiSelectMode();
      }
      if (context.read<MultiselectProvider>().isTasksMultiSelectMode) {
        context.read<MultiselectProvider>().toggleTasksMultiSelectMode();
      }

      currentPageIndex = navigationIndex;

      _pageController.animateToPage(
        navigationIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void deleteSelectedNotes(NoteProvider noteProvider, MultiselectProvider multiselectProvider, RecicleBinProvider binProvider) {
    ConfirmationDialog(context: context, message: AppLocalizations.of(context)!.confirmation_dialog_delete_notes).showConfirmationDialog(context).then((confirmation) {
      if (confirmation == true) {
        multiselectProvider.deleteSelectedNotes(noteProvider, binProvider);
      }
    });
  }

  void deleteSelectedTasks(TaskProvider taskProvider, MultiselectProvider multiselectProvider, RecicleBinProvider binProvider) {
    ConfirmationDialog(context: context, message: AppLocalizations.of(context)!.confirmation_dialog_delete_tasks).showConfirmationDialog(context).then((confirmation) {
      if (confirmation == true) {
        multiselectProvider.deleteSelectedTasks(taskProvider, binProvider);
      }
    });
  }
}



// WIDGETS

class _NewNoteButton extends StatelessWidget {

  const _NewNoteButton();

  @override
  Widget build(BuildContext context) {

    final MultiselectProvider multiselectProvider = context.read<MultiselectProvider>();

    return IconButton(
      iconSize: 50,
      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 187, 140, 0))),
      icon: const Icon(Icons.note_add),
      onPressed: () {
        if(multiselectProvider.isNotesMultiSelectMode){
          multiselectProvider.toggleNotesMultiSelectMode();
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewNoteScreen()));
      },
    );
  }
}

class _NewTaskButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final MultiselectProvider multiselectProvider = context.read<MultiselectProvider>();

    return IconButton(
      iconSize: 50,
      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromARGB(164, 255, 193, 7))),
      icon: const Icon(Icons.add_box_outlined),
      onPressed: () {
        if(multiselectProvider.isTasksMultiSelectMode){
          multiselectProvider.toggleTasksMultiSelectMode();
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewTaskScreen()));
      },
    );
  }
}
