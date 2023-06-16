import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSharedPreferenceProvider extends ChangeNotifier{
  bool getBoolLogin = false;

  void getValue()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    getBoolLogin = pref.getBool("Login") ?? false;
    notifyListeners();
  }
}