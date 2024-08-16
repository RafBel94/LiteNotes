import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String appBarTitle;

  UserProvider({this.appBarTitle = "Notes"});

  void changeAppBarTitle({required String text}) async {
    appBarTitle = text;
    notifyListeners();
  }
}