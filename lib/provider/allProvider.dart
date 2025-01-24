import 'package:flutter/material.dart';
import 'package:mariaivarsreservas/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllProvider with ChangeNotifier {
  AllProvider() {
    loadData();
  }

  int _selectDesign = Constant.selectVista;
  int get selectDesign => _selectDesign;

  void setSelectScreen(int newData) async {
    _selectDesign = newData;
    notifyListeners();
  }

  Future<void> loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Constant.selectVista = prefs.getInt('selectVista') ?? 0;
    _selectDesign=  Constant.selectVista ;

    notifyListeners();
  }
}
