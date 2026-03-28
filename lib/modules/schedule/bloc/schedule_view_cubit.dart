import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ScheduleViewCubit extends Cubit<bool> {
  ScheduleViewCubit() : super(true);
  Box get _box => Hive.box("settings");

  void initView() async {
    final isCard = _box.get('cardView', defaultValue: true);
    emit(isCard);
  }

  void toggleView() async {
    final newValue = !state;
    emit(newValue);
    await _box.put('cardView', newValue);
  }
}
