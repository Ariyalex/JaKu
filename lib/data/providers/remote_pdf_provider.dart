import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jaku/core/utils/time_parser_helper.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/models/matkul_model.dart';
import 'package:jaku/data/models/schedule_model.dart';
import 'package:jaku/data/value_objects/day.dart';

class RemotePdfProvider {
  final Dio dio;
  RemotePdfProvider({required this.dio});

  Future<({List<MatkulModel> matkuls, List<ScheduleModel> schedules})>
  uploadAndProcessPdf(File file) async {
    try {
      String fileName = file.path.split('/').last;
      String baseUrl = dotenv.env['BASE_URL']!;

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await dio.post(
        '$baseUrl/usukaparse',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          followRedirects: false,
        ),
      );

      // Ambil data dari response.data sebelum melakukan cast ke Map
      final data = response.data as Map<String, dynamic>;

      List<MatkulModel> matkulList = [];
      List<ScheduleModel> scheduleList = [];

      for (Map<String, dynamic> matkul in data['matkuls'] as List<dynamic>) {
        List<dynamic> lecturerList = matkul['lecturers'] ?? [];
        String? lecturer1 = lecturerList.isNotEmpty
            ? lecturerList[0]['name']
            : null;
        String? lecturer2 = lecturerList.length > 1
            ? lecturerList[1]['name']
            : null;

        matkulList.add(
          MatkulModel(
            id: matkul['id'],
            name: matkul['name'],
            nameAbbreviation: Matkul.matkulAbbreviation(matkul['name']),
            lecturer1: lecturer1,
            lecturer2: lecturer2,
            semester: -1,
          ),
        );

        List<dynamic> schedules = matkul['schedules'] ?? [];
        for (var schedule in schedules) {
          scheduleList.add(
            ScheduleModel(
              id: schedule['id'],
              matkulId: matkul['id'],
              day: Day.stringToDay(schedule['day']),
              startTime: TimeParserHelper.parseTimeOfDay(
                schedule['start_time'],
              ),
              endTime: TimeParserHelper.parseTimeOfDay(schedule['end_time']),
              room: schedule['room'],
              alarms: [],
            ),
          );
        }
      }

      return (matkuls: matkulList, schedules: scheduleList);
    } catch (e) {
      rethrow;
    }
  }
}
