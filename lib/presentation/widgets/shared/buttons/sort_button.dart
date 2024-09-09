import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/screens/providers/recicle_bin_provider.dart';
import 'package:simple_notes/presentation/screens/providers/task_provider.dart';
import 'package:simple_notes/presentation/widgets/shared/main_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SortButton extends StatefulWidget {

  final bool isDeletedScreen;
  final String? objectType;
  
  const SortButton({
    super.key, required this.isDeletedScreen, this.objectType
  });
  
  @override
  SortButtonState createState() => SortButtonState();
}

class SortButtonState extends State<SortButton> {
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    // Find the state of its ancestor to access its methods and attributes
    final MainScaffoldState? skeletonState = context.findAncestorStateOfType<MainScaffoldState>();

    NoteProvider noteProvider = context.read<NoteProvider>();
    TaskProvider taskProvider = context.read<TaskProvider>();
    RecicleBinProvider binProvider = context.read<RecicleBinProvider>();

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
            if(skeletonState?.currentPageIndex == 0){
              noteProvider.sortListAlphabetically(descendent: true);
            } else {
              taskProvider.sortListAlphabetically(descendent: true);
            }
            break;
          }
          case 2: {
            if(skeletonState?.currentPageIndex == 0){
              noteProvider.sortListAlphabetically(descendent: false);
            } else {
              taskProvider.sortListAlphabetically(descendent: false);
            }
            break;
          }
          case 3: {
            if(skeletonState?.currentPageIndex == 0){
              noteProvider.sortListByModifiedDate(recentFirst: true);
            } else {
              taskProvider.sortListByCreationDate(recentFirst: true);
            }
            break;
          }
          case 4: {
            if(skeletonState?.currentPageIndex == 0){
              noteProvider.sortListByModifiedDate(recentFirst: false);
            } else {
              taskProvider.sortListByCreationDate(recentFirst: false);
            }
            break;
          }
          case 5: {
            binProvider.sortByDeleteDate(recentFirst: true, type: widget.objectType!);
            break;
          }
          case 6: {
            binProvider.sortByDeleteDate(recentFirst: false, type: widget.objectType!);
            break;
          }
        }
        setState(() {
          isMenuOpen = false;
        });
      },
      itemBuilder: (context) {
        return widget.isDeletedScreen ? deletedEntryList() : notDeletedEntryList();
      },
    );
  }
  
  List<PopupMenuEntry<int>> notDeletedEntryList() {
    return <PopupMenuEntry<int>>[
      PopupMenuItem(
        value: 1,
        child: Text(AppLocalizations.of(context)!.sort_alphabetically_a_z),
      ),
      PopupMenuItem(
        value: 2,
        child: Text(AppLocalizations.of(context)!.sort_alphabetically_z_a),
      ),
      PopupMenuItem(
        value: 3,
        child: Text(AppLocalizations.of(context)!.sort_by_last_modified_recent),
      ),
      PopupMenuItem(
        value: 4,
        child: Text(AppLocalizations.of(context)!.sort_by_last_modified_older),
      ),
    ];
  }
  
  List<PopupMenuEntry<int>> deletedEntryList() {
    return <PopupMenuEntry<int>>[
      PopupMenuItem(
        value: 5,
        child: Text(AppLocalizations.of(context)!.sort_by_delete_date_recent),
      ),
      PopupMenuItem(
        value: 6,
        child: Text(AppLocalizations.of(context)!.sort_by_delete_date_older),
      ),
    ];
  }
}