import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/presentation/screens/notes/deleted_note_screen.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/screens/providers/recicle_bin_provider.dart';
import 'package:simple_notes/presentation/screens/notes/user_note_screen.dart';

class NoteButton extends StatefulWidget {
  final Note note;
  final bool isDeleted;
  final bool isMultiSelectMode;
  final bool isSelected;
  final VoidCallback onLongPress;
  final VoidCallback onSelected;

  const NoteButton({
    super.key,
    required this.note,
    required this.isDeleted,
    required this.isMultiSelectMode,
    required this.isSelected,
    required this.onLongPress,
    required this.onSelected,
  });

  @override
  NoteButtonState createState() => NoteButtonState();
}

class NoteButtonState extends State<NoteButton> with SingleTickerProviderStateMixin {
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
    final RecicleBinProvider binProvider = context.read<RecicleBinProvider>();
    final NoteProvider noteProvider = context.read<NoteProvider>();

    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Stack(
          children: [
            SizedBox.expand(
              child: TextButton(
                style: TextButton.styleFrom(
                  side: BorderSide(
                    color: (widget.note.group != null && !widget.isDeleted)
                        ? widget.note.group!.color
                        : Colors.transparent,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color.fromARGB(25, 158, 158, 158),
                ),
                onPressed: () {
                  if (!widget.isDeleted && !widget.isMultiSelectMode) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserNoteScreen(
                          note: widget.note,
                          noteProvider: noteProvider,
                        ),
                      ),
                    );
                  } else if (widget.isMultiSelectMode) {
                    widget.onSelected();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeletedNoteScreen(
                          note: widget.note,
                          binProvider: binProvider,
                        ),
                      ),
                    );
                  }
                },
                child: Column(
                  children: [
                    Text(
                      widget.note.title,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 242, 221, 159),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Expanded(
                      child: Text(
                        widget.note.text,
                        style: const TextStyle(fontSize: 15, color: Colors.white),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.isMultiSelectMode)
              Positioned(
                top: -2,
                right: 0,
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
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
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
}
