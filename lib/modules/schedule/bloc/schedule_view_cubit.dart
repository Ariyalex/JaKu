import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ScheduleViewCubit extends Cubit<bool> {
  ScheduleViewCubit() : super(true);

  void initView() async {
    final box = await Hive.openBox("settings");
    final isCard = box.get('cardView', defaultValue: true);
    emit(isCard);
  }

  void toggleView() async {
    final newValue = !state;
    emit(newValue);
    final box = await Hive.openBox("settings");
    await box.put('cardView', newValue);
  }
}
