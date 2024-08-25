import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/group.dart';
import 'package:simple_notes/presentation/screens/providers/group_provider.dart';

class NoteGroupsScrollView extends StatelessWidget {
  const NoteGroupsScrollView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final GroupProvider groupProvider = context.read<GroupProvider>();

    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: groupProvider.groupList.length,
        itemBuilder: (context, index) {
          final Group group = groupProvider.groupList[index];

          return TextButton.icon(onPressed: () {}, icon: Icon(Icons.square_rounded, color: group.color), label: Text(group.name));
        },
      ),
    );
  }
}