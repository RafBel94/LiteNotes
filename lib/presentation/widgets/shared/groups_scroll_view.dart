import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/group.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/presentation/screens/providers/group_provider.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';

class GroupsScrollView extends StatefulWidget {
  final Note? note;

  const GroupsScrollView({super.key, this.note});

  @override
  NoteGroupsScrollViewState createState() => NoteGroupsScrollViewState();
}

class NoteGroupsScrollViewState extends State<GroupsScrollView> {
  Group? selectedGroup;

  @override
  void initState() {
    super.initState();
    selectedGroup = widget.note?.group;
  }

  @override
  Widget build(BuildContext context) {
    final GroupProvider groupProvider = context.read<GroupProvider>();
    final NoteProvider noteProvider = context.read<NoteProvider>();
    final List<Group> filteredList = groupProvider.groupList.where((g) => g != widget.note?.group).toList();

    if( widget.note?.group != noteProvider.defaultGroup && widget.note?.group != null){
      filteredList.add(noteProvider.defaultGroup);
    }

    final List<Widget> availableGroups = getAvailableGroups(filteredList, noteProvider);

    return filteredList.isEmpty ? const SizedBox.shrink() : Column(children: availableGroups);
  }

  
  
  List<Widget> getAvailableGroups(List<Group> filteredList, NoteProvider noteProvider) {
    return [
      Container(
        height: 40,
        margin: const EdgeInsets.only(bottom: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            final Group group = filteredList[index];

            if(filteredList[index] != noteProvider.defaultGroup){
              return Container(
                padding: const EdgeInsets.only(right: 5),
                child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedGroup = group;
                      });
                    },
                    icon: Icon(Icons.square_rounded, color: group.color),
                    label: Text(group.name),
                    style: TextButton.styleFrom(
                        side: BorderSide(color: selectedGroup == group ? const Color.fromARGB(255, 255, 215, 95) : Colors.grey),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                        )
                    ),
              );
            } else {
              return Container(
                padding: const EdgeInsets.only(right: 5),
                child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedGroup = group;
                      });
                    },
                    icon: Icon(Icons.disabled_by_default_outlined, color: group.color),
                    label: const Text('No group'),
                    style: TextButton.styleFrom(
                        side: BorderSide(color: selectedGroup == group ? const Color.fromARGB(255, 255, 215, 95) : Colors.grey),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                        )
                    ),
              );
            }
          },
        ),
      ),
    ];
  }

  Group? getSelectedGroup() {
    return selectedGroup;
  }
}
