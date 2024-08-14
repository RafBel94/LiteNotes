
import 'package:flutter/material.dart';
import 'package:read_write_app/config/infracstructure/app_theme.dart';
import 'package:read_write_app/presentation/screens/list_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 0).getTheme(),
      title: 'Material App',
      home: ListScreen()
    );
  }
}
