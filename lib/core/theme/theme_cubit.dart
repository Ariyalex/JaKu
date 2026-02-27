import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  final _box = Hive.box('settings');

  void initTheme() {
    final bool? isLight = _box.get("isLight");
    if (isLight == null) {
      emit(ThemeMode.system);
    } else {
      emit(isLight ? ThemeMode.light : ThemeMode.dark);
    }
  }

  void toggleTheme() {
    final isLight = state == ThemeMode.light;

    _box.put("isLight", !isLight);
    emit(!isLight ? ThemeMode.light : ThemeMode.dark);
  }
}
