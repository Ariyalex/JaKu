import 'package:get/get.dart';
import 'package:jaku/controllers/note_controllers/note_controllers.dart';
import 'package:jaku/controllers/task_controllers/task_controller.dart';

class DetailJadwalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NoteControllers());
    Get.put(TaskController());
  }
}
