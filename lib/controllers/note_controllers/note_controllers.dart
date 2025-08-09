import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jaku/models/note.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class NoteControllers extends GetxController {
  final titleC = TextEditingController();
  final noteC = TextEditingController();
  RxnString matkulC = RxnString();
  RxBool isSortByCreatedDate = true.obs;

  final RxBool isLoading = false.obs;

  final RxList<Note> allNote = <Note>[].obs;
}
