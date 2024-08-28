import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/group.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/presentation/screens/providers/group_provider.dart';

class NoteGroupsScrollView extends StatefulWidget {
  final Note? note;

  const NoteGroupsScrollView({super.key, this.note});

  @override
  NoteGroupsScrollViewState createState() => NoteGroupsScrollViewState();
}

class NoteGroupsScrollViewState extends State<NoteGroupsScrollView> {
  Group? selectedGroup;

  @override
  void initState() {
    super.initState();
    selectedGroup = widget.note?.group;
  }

  @override
  Widget build(BuildContext context) {
    final GroupProvider groupProvider = context.read<GroupProvider>();
    final List<Group> filteredList = groupProvider.groupList.where((g) => g != widget.note?.group).toList();
    final List<Widget> availableGroups = [
      Align(
        alignment: Alignment.center,
        child: Container(
            padding: const EdgeInsets.only(bottom: 5),
            child: const Text(
              'Groups:',
              style: TextStyle(fontSize: 18, color: Colors.white),
            )),
      ),
      Container(
        height: 40,
        margin: const EdgeInsets.only(bottom: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            final Group group = filteredList[index];

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
          },
        ),
      ),
    ];

    return filteredList.isEmpty ? 
    const SizedBox.shrink() : 
    Column(
      children: availableGroups,
    );
  }

  Group? getSelectedGroup() {
    return selectedGroup;
  }
}
