import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  // GetStorage에 isDarkMode 저장 메소드, themeMode 전환시 필요
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  ThemeMode get theme => _loadThemeFromBox()
      ? ThemeMode.dark : ThemeMode.light;

  // themeMode function
  void switchTheme() {
    Get.changeThemeMode( _loadThemeFromBox()
        ? ThemeMode.light : ThemeMode.dark);
    // themMode 변화 함수
    _saveThemeToBox(!_loadThemeFromBox());
  }
}
