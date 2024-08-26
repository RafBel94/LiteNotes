import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/group.dart';
import 'package:simple_notes/presentation/screens/providers/group_provider.dart';

class NoteGroupsScrollView extends StatefulWidget {
  const NoteGroupsScrollView({
    super.key,
  });
  
  @override
  NoteGroupsScrollViewState createState() => NoteGroupsScrollViewState();

}

class NoteGroupsScrollViewState extends State<NoteGroupsScrollView> {
  Group? selectedGroup;

  @override
  Widget build(BuildContext context) {

    final GroupProvider groupProvider = context.read<GroupProvider>();

    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.only(bottom: 5),
            child: const Text('Available groups:', style: TextStyle(fontSize: 17, color: Colors.amber),)
          ),
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.only(bottom: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: groupProvider.groupList.length,
            itemBuilder: (context, index) {
              final Group group = groupProvider.groupList[index];
        
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
                    side:  BorderSide(
                      color: selectedGroup == group ? const Color.fromARGB(255, 255, 215, 95) : Colors.grey
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                  )
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Group? getSelectedGroup() {
    return selectedGroup;
  }
}