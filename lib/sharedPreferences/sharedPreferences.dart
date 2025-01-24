import 'package:shared_preferences/shared_preferences.dart';

import '../Constant/constant.dart';

class DataPreferences {
  static Future<void> cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();

    Constant.alreadyInit = prefs.getBool('remember_me') ?? false;
    Constant.selectVista = prefs.getInt('selectVista') ?? 0;
    print(Constant.selectVista.toString() + "weeee");
  }
}
