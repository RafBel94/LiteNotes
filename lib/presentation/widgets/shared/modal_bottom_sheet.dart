import 'package:flutter/material.dart';

class ModalBottomSheet {
  final DateTime? creationDate;
  final DateTime? modifiedDate;

  ModalBottomSheet(this.modifiedDate, {required this.creationDate});

  void showInfoMenu(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (context) {
        return SizedBox(
            width: size.width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Creation date:   ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      TextSpan(text: creationDate.toString().split('.').first, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Modified date:   ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      TextSpan(text: modifiedDate.toString().split('.').first, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ));
      },
    );
  }
}
