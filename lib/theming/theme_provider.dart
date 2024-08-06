import 'package:flutter/material.dart';
import 'themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = MyThemes.MyLightTheme;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == MyThemes.MyDarkTheme;

  void set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if(_themeData == MyThemes.MyDarkTheme){
      _themeData = MyThemes.MyLightTheme;
    }else {
      _themeData = MyThemes.MyDarkTheme;
    }
    notifyListeners();
  }
}