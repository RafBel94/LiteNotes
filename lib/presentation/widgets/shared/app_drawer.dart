import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/group.dart';
import 'package:simple_notes/presentation/screens/providers/group_provider.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/widgets/dialogs/new_group_dialog.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final GroupProvider groupProvider = context.watch<GroupProvider>();
    final NoteProvider noteProvider = context.read<NoteProvider>();

    return Drawer(
      elevation: 40,
      backgroundColor: const Color.fromARGB(255, 18, 18, 17),
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
                child: Text('Menu', style: TextStyle(color: Colors.black, fontSize: 24,),),
              ),
            ),
          ),


          ExpansionTile(
            title: const Text('Note Groups'),
            collapsedBackgroundColor: const Color.fromARGB(255, 39, 35, 21),
            backgroundColor: const Color.fromARGB(255, 67, 60, 37),
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
                                style: const ButtonStyle(overlayColor: WidgetStatePropertyAll(Colors.transparent)),
                                child: Text(provider.groupList[index].name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, color: Colors.white),),
                                onPressed: () {
                                  // Set current filtered group to the selected one
                                  noteProvider.updateFilteredGroup(provider.groupList[index]);
                                },
                              ),
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
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      Text(
                        '  New group',
                        style: TextStyle(color: Colors.white, fontSize: 17),
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
        ],
      ),
    );
  }

  
  
  Future<bool?> getDeleteConfirmation(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Confirmation"),
          content: const Text("Do you want to delete this group?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Accept"),
            ),
          ],
        );
      },
    );
  }
}