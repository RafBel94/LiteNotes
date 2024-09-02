import 'package:flutter/material.dart';

class NoteInfoBottomSheet {
  final DateTime? creationDate;
  final DateTime? modifiedDate;
  final DateTime? deletedDate;

  NoteInfoBottomSheet(this.modifiedDate, {required this.creationDate, this.deletedDate});

  void showInfoMenu(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: const Color.fromARGB(255, 46, 46, 46),
      builder: (context) {
        return SizedBox(
          width: size.width * 0.75,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10,),

              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(text: 'Creation date:   ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    TextSpan(text: creationDate.toString().split('.').first, style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),

              const SizedBox(height: 10,),

              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan( text: 'Modified date:   ',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    TextSpan(text: modifiedDate.toString().split('.').first, style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),

              const SizedBox(height: 10,),

              if(deletedDate != null)
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan( text: 'Deletion date:   ',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    TextSpan(text: deletedDate.toString().split('.').first, style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),

               const SizedBox(height: 10,)
            ],
          )
        );
      },
    );
  }
}
