import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/group.dart';
import 'package:simple_notes/presentation/screens/providers/group_provider.dart';
import 'package:simple_notes/presentation/screens/providers/multiselect_provider.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/screens/recicle_bin_notes_screen.dart';
import 'package:simple_notes/presentation/screens/recicle_bin_tasks_screen.dart';
import 'package:simple_notes/presentation/widgets/dialogs/edit_group_dialog.dart';
import 'package:simple_notes/presentation/widgets/dialogs/new_group_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  final Function(Locale) onLanguageChanged;
  const AppDrawer({super.key, required this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    final GroupProvider groupProvider = context.watch<GroupProvider>();
    final NoteProvider noteProvider = context.read<NoteProvider>();
    final MultiselectProvider multiselectProvider = context.read<MultiselectProvider>();
    
    disableMultiSelect(multiselectProvider);

    return Drawer(
      elevation: 40,
      backgroundColor: const Color.fromARGB(255, 18, 18, 17),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[

          Container(
            height: 80,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 254, 204, 54),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(AppLocalizations.of(context)!.drawer_title, style: const TextStyle(color: Colors.black, fontSize: 24,),),
              ),
            ),
          ),


          ExpansionTile(
            title: Text(AppLocalizations.of(context)!.drawer_groups_tile),
            collapsedBackgroundColor: const Color.fromARGB(255, 48, 48, 47),
            backgroundColor: const Color.fromARGB(255, 90, 90, 90),
            leading: const Icon(Icons.account_tree, color: Color.fromARGB(255, 235, 208, 125)),
            children: <Widget>[

              Consumer<GroupProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.groupList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: const Color.fromARGB(255, 30, 30, 27),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Icon(Icons.square, color: provider.groupList[index].color,),
                            ),

                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                  )
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(provider.groupList[index].name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  // Set current filtered group to the selected one
                                  noteProvider.updateFilteredGroup(provider.groupList[index]);
                                },
                              ),
                            ),
                            
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                EditGroupDialog().editGroup(context, provider.groupList[index]);
                              },
                            ),
                            
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                getDeleteConfirmation(context).then((confirmation) {
                                  if (confirmation == true) {
                                    Group group = provider.groupList[index];
                                    noteProvider.updateNoteGroups(group);
                                    groupProvider.removeGroup(group);
                                  }
                                });
                                
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),


              Container(
                color: const Color.fromARGB(255, 30, 30, 27),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add),
                      Text(
                        AppLocalizations.of(context)!.drawer_new_group_button,
                        style: const TextStyle(color: Colors.white, fontSize: 17),
                      )
                    ],
                  ),
                  onTap: () {
                    NewGroupDialog().createGroupDialog(context);
                  },
                ),
              ),
            ],
          ),

          ExpansionTile(
            title: Text(AppLocalizations.of(context)!.drawer_recicle_bin),
            collapsedBackgroundColor: const Color.fromARGB(255, 48, 48, 47),
            backgroundColor: const Color.fromARGB(255, 90, 90, 90),
            leading: const Icon(Icons.delete, color: Color.fromARGB(255, 235, 208, 125)),
            children: <Widget>[

              Container(
                color: const Color.fromARGB(255, 30, 30, 27),
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                  ),
                  icon: const Icon(Icons.note_rounded),
                  label: Text(AppLocalizations.of(context)!.drawer_recicle_bin_notes, style: const TextStyle(color: Colors.white)),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RecicleBinNotesScreen()));
                  }
                ),
              ),

              Container(
                color: const Color.fromARGB(255, 30, 30, 27),
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                  ),
                  icon: const Icon(Icons.checklist),
                  label: Text(AppLocalizations.of(context)!.drawer_recicle_bin_tasks, style: const TextStyle(color: Colors.white)),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RecicleBinTasksScreen()));
                  }
                ),
              ),
              
            ],
          ),

          ExpansionTile(
            title: Text(AppLocalizations.of(context)!.drawer_language),
            collapsedBackgroundColor: const Color.fromARGB(255, 48, 48, 47),
            backgroundColor: const Color.fromARGB(255, 90, 90, 90),
            leading: const Icon(Icons.language, color: Color.fromARGB(255, 235, 208, 125)),
            children: <Widget>[

              Container(
                color: const Color.fromARGB(255, 30, 30, 27),
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                  ),
                  icon: const Icon(Icons.settings_applications_sharp),
                  label: Text(AppLocalizations.of(context)!.language_spanish, style: const TextStyle(color: Colors.white)),
                  onPressed: (){
                    onLanguageChanged(const Locale('es'));
                  }
                ),
              ),

              Container(
                color: const Color.fromARGB(255, 30, 30, 27),
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                  ),
                  icon: const Icon(Icons.settings_applications_sharp),
                  label: Text(AppLocalizations.of(context)!.language_english, style: const TextStyle(color: Colors.white)),
                  onPressed: (){
                    onLanguageChanged(const Locale('en'));
                  }
                ),
              ),
              
            ],
          ),


        ],
      ),
    );
  }

  
  
  Future<bool?> getDeleteConfirmation(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.delete_confirmation),
          content: Text(AppLocalizations.of(context)!.delete_group),
          backgroundColor: const Color.fromARGB(255, 30, 30, 27),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(AppLocalizations.of(context)!.accept),
            ),
          ],
        );
      },
    );
  }
  
  void disableMultiSelect(MultiselectProvider multiselectProvider) {
    if(multiselectProvider.isNotesMultiSelectMode){
      multiselectProvider.toggleNotesMultiSelectMode();
    } else if (multiselectProvider.isTasksMultiSelectMode){
      multiselectProvider.toggleTasksMultiSelectMode();
    }
  }
}