import 'package:flutter/material.dart';

class DbChangeNotifier extends ChangeNotifier {
  void notifyChange() {
    notifyListeners();
  }
}