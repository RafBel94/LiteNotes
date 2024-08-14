import 'package:flutter/material.dart';

const List<Color> _colorList = [Color.fromRGBO(192, 150, 25, 1), Color.fromARGB(255, 40, 234, 215), Color.fromRGBO(172, 124, 255, 1)];

class AppTheme {
  final int selectedColor;

  AppTheme({required this.selectedColor})
  : assert(selectedColor >= 0 && selectedColor <= 2, 'The value must be between ${_colorList.length - 1}');

  ThemeData getTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      colorSchemeSeed: _colorList[selectedColor]
    );
  }

}