
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_write_app/config/infracstructure/app_theme.dart';
import 'package:read_write_app/presentation/screens/providers/note_provider.dart';
import 'package:read_write_app/presentation/screens/providers/user_provider.dart';
import 'package:read_write_app/presentation/screens/skeleton.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => NoteProvider())
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 0).getTheme(),
      title: 'Material App',
      home: const Skeleton()
    )
    );
    
      
  }
}
