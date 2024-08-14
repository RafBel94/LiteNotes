import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 254, 204, 54),
        centerTitle: true,
        title: const Text('Chores list', style: TextStyle(color: Colors.black),),
        actions: [
          _NewButton(),
          _InfoButton()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
        child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              _NoteButton(),
              _NoteButton(),
              _NoteButton(),
              _NoteButton(),
              _NoteButton(),
              _NoteButton(),
              _NoteButton(),
              _NoteButton(),
            ],),
        ),
        floatingActionButton: IconButton(
          iconSize: 50,
          style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromARGB(164, 255, 193, 7))),
          icon: const Icon(Icons.new_label),
          onPressed: () {
            
          },
        ),
      );
  }
}


class _NoteButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), backgroundColor: const WidgetStatePropertyAll(Color.fromARGB(25, 158, 158, 158))),
      onPressed: () {
    
      },
      child: const Text('Chore', style: TextStyle(fontSize: 40, color: Colors.white),)
      );
  }
}

class _InfoButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_outline),
      color: Colors.black,
      onPressed: () {
        
      },);
  }
}

class _NewButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.new_label),
      color: Colors.black,
      onPressed: () {
        
      },
    );
  }
}