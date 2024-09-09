import 'package:flutter/material.dart';
import 'package:simple_notes/domain/entities/task.dart';
import 'package:simple_notes/domain/entities/task_check.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_notes/presentation/screens/tasks/deleted_task_screen.dart';
import 'package:simple_notes/presentation/screens/tasks/user_task_screen.dart';

class TaskButton extends StatefulWidget {
  final Task task;
  final bool isMultiSelectMode;
  final bool isSelected;
  final bool isDeleted;
  final VoidCallback onLongPress;
  final VoidCallback onSelected;

  const TaskButton({
    super.key,
    required this.task,
    required this.isMultiSelectMode,
    required this.isSelected,
    required this.onLongPress,
    required this.onSelected,
    required this.isDeleted,
  });

  @override
  TaskButtonState createState() => TaskButtonState();
}

class TaskButtonState extends State<TaskButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeButtonAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Stack(
          children: [
            
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(25, 158, 158, 158),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  onPressed: () {
                    if (!widget.isDeleted && !widget.isMultiSelectMode) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserTaskScreen(
                            task: widget.task,
                          ),
                        ),
                      );
                    } else if (widget.isMultiSelectMode) {
                      widget.onSelected();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeletedTaskScreen(
                            task: widget.task,
                          ),
                        ),
                      );
                    }
                  },
                  onLongPress: widget.onLongPress,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.task.title,
                              style: const TextStyle(fontSize: 22, color: Colors.white),
                            ),

                            if(!widget.isDeleted)
                            Text(
                              '${AppLocalizations.of(context)!.creation_date}  ${widget.task.creationDate.toIso8601String().split('T').first}',
                              style: const TextStyle(fontSize: 15, color: Colors.white70),
                            ),

                            if(widget.isDeleted)
                            Text(
                              '${AppLocalizations.of(context)!.delete_date}  ${widget.task.deletedDate?.toIso8601String().split('T').first}',
                              style: const TextStyle(fontSize: 15, color: Colors.white70),
                            ),
                          ],
                        ),

                        const Spacer(),

                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Text(
                            '${countDoneChecks(widget.task.checkList)}/${widget.task.checkList.length}',
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            if (widget.isMultiSelectMode)
              Positioned(
                top: 8,
                right: -2,
                child: Radio(
                  groupValue: true,
                  toggleable: true,
                  value: widget.isSelected,
                  onChanged: (value) {
                    widget.onSelected();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _initializeButtonAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  String countDoneChecks(List<TaskCheck> checkList) {
    int doneChecks = 0;
    for (TaskCheck taskCheck in checkList) {
      if (taskCheck.done) {
        doneChecks++;
      }
    }
    return doneChecks.toString();
  }
}
