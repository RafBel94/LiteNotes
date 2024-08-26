import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/group.dart';
import 'package:simple_notes/presentation/screens/providers/group_provider.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final GroupProvider groupProvider = context.watch<GroupProvider>();
    final NoteProvider noteProvider = context.read<NoteProvider>();

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
                child: Text('Menu', style: TextStyle(color: Colors.black, fontSize: 24,),),
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
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 138, 115, 50))),
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
                    _newGroupDialog(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> _newGroupDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          GroupProvider groupProvider = context.read<GroupProvider>();
          final TextEditingController txtController = TextEditingController();
          Color selectedColor = Colors.cyan;

          return AlertDialog(
            title: const Text('Insert new group name:'),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            actions: [
              TextField(
                style: const TextStyle(fontSize: 20),
                controller: txtController,
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                  alignment: Alignment.center,
                  child: TextButton(
                      onPressed: () async {
                        selectedColor = await _showColorPicker(context, selectedColor);
                      },
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 239, 208, 115))),
                          child: const Text(
                            'SELECT COLOR',
                            style: TextStyle(fontSize: 20),
                          )))),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                  onPressed: () {
                    if(txtController.value.text.trim().isNotEmpty){
                      groupProvider.addGroup(Group.create(name: txtController.value.text, color: selectedColor));
                      Navigator.of(context).pop();
                    }else{
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Warning', style: TextStyle(color: Color.fromARGB(255, 249, 208, 86))),
                              content: const Text('The group name cannot be empty', style: TextStyle(fontSize: 20)),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK', style: TextStyle(fontSize: 20))
                                )
                              ],
                            );
                          });
                    }
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          );
        });
  }
  
  Future<Color> _showColorPicker(BuildContext context, Color currentColor) async {
    Color selectedColor = currentColor;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                selectedColor = color;
              },
              labelTypes: const [],
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK', style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return selectedColor;
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