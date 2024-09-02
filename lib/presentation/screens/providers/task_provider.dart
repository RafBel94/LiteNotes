import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_notes/domain/entities/task.dart';

class TaskProvider extends ChangeNotifier{
  List<Task> taskList = [];

  Future<void> initialize() async {
    await loadTasks();
  }

  void addTask(Task task) {
    taskList.add(task);
    saveTaskList(taskList);
    notifyListeners();
  }

  void removeTask(Task task) {
    taskList.remove(task);
    saveTaskList(taskList);
    notifyListeners();
  }

  void updateTask(Task task) {
    int index = taskList.indexWhere((Task t) => t.id == task.id);
    if (index != -1) {
      taskList[index] = task;
      saveTaskList(taskList);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void sortListAlphabetically({required bool descendent}) {
    if(descendent) {
      // Ascendent ASCII value
      taskList.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    } else {
      // Descendent ASCII value
      taskList.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
    }

    notifyListeners();
  }

  void sortListByCreationDate({required bool recentFirst}) {
    if(recentFirst) {
      taskList.sort((a,b) => b.creationDate.compareTo(a.creationDate));
    } else {
      taskList.sort((a,b) => a.creationDate.compareTo(b.creationDate));
    }

    notifyListeners();
  }
  
  // METHODS RELATED TO READ/SAVE OF DATA LOCALLY

  Future<void> loadTasks() async {
    taskList = await readJson('tasks_data.json');
    notifyListeners();
  }

  String listToJson(List<Task> taskList) {
    List<Map<String, dynamic>> mapList = taskList.map((task) => task.toJson()).toList();
    String jsonString = jsonEncode(mapList);

    return jsonString;
  }

  Future<void> saveJson(String jsonContent, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName';
    final file = File(path);
    await file.writeAsString(jsonContent);
  }

  Future<void> saveTaskList(List<Task> taskList) async {
    String jsonString = listToJson(taskList);
    await saveJson(jsonString, 'tasks_data.json');
  }

  Future<List<Task>> readJson(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName';
    final file = File(path);

    if (await file.exists()) {
      String jsonContent = await file.readAsString();
      List<dynamic> jsonList = jsonDecode(jsonContent);
      return jsonList.map((json) => Task.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}