import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/matkul_controller.dart';
import 'package:jaku/data/models/matkul.dart';
import 'package:jaku/data/value_objects/day.dart';
import 'package:jaku/services/matkul_schedule_service.dart';
import 'package:jaku/services/matkul_service.dart';
import 'package:jaku/core/theme/theme.dart';
import 'package:jaku/core/utils/snackbar_widget.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/matkul_schedule.dart';

class MatkulScheduleDetailController extends GetxController {
  final MatkulScheduleService scheduleService;
  MatkulScheduleDetailController({required this.scheduleService});

  Rxn<Matkul> selectedMatkulController = Rxn<Matkul>();
  Rxn<Day> selectedDay = Rxn<Day>();
  Rxn<DateTime> selectedStartTime = Rxn<DateTime>();
  Rxn<DateTime> selectedEndTime = Rxn<DateTime>();

  late MatkulSchedule selectedSchedule;

  final Set<String> kelasList = {"A", "B", "C", "D", "E", "F"};
}
