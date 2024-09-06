import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoteInfoBottomSheet {
  final DateTime? creationDate;
  final DateTime? modifiedDate;
  final DateTime? deletedDate;

  NoteInfoBottomSheet(this.modifiedDate, {required this.creationDate, this.deletedDate});

  void showInfoMenu(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                    TextSpan(text: '${AppLocalizations.of(context)!.creation_date}   ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    TextSpan(text: creationDate.toString().split('.').first, style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ),

              const SizedBox(height: 10,),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: '${AppLocalizations.of(context)!.modification_date}   ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    TextSpan(text: modifiedDate.toString().split('.').first, style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ),

              const SizedBox(height: 10,),

              if(deletedDate != null)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: '${AppLocalizations.of(context)!.delete_date}   ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    TextSpan(text: deletedDate.toString().split('.').first, style: const TextStyle(fontSize: 15)),
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
