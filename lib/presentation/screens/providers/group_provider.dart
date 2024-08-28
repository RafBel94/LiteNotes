import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_notes/domain/entities/group.dart';

class GroupProvider extends ChangeNotifier{
  List<Group> groupList = [];

  GroupProvider(){
    loadGroups();
  }

  Future<void> loadGroups() async {
    groupList = await readJson('groups_data.json');
    notifyListeners();
  }

  void addGroup(Group group) {
    groupList.add(group);
    saveGroupList(groupList);
    notifyListeners();
  }

  void removeGroup(Group group) {
    groupList.remove(group);
    saveGroupList(groupList);
    notifyListeners();
  }

  void updateGroup(Group group) {
    for(Group g in groupList){
      if(g.id == group.id){
        g = group;
        saveGroupList(groupList);

        // Wait to all operations to finish before notify listeners
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });

      break;
      }
    }
  }

  String listToJson(List<Group> groupList) {
    List<Map<String, dynamic>> mapList = groupList.map((group) => group.toJson()).toList();
    String jsonString = jsonEncode(mapList);
    return jsonString;
  }

  Future<void> saveJson(String jsonContent, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName';
    final file = File(path);
    await file.writeAsString(jsonContent);
  }

  Future<void> saveGroupList(List<Group> noteList) async {
    String jsonString = listToJson(noteList);
    await saveJson(jsonString, 'groups_data.json');
  }

  Future<List<Group>> readJson(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName';
    final file = File(path);

    if (await file.exists()) {
      String jsonContent = await file.readAsString();
      List<dynamic> jsonList = jsonDecode(jsonContent);
      return jsonList.map((json) => Group.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}

