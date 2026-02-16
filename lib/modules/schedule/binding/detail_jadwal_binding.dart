import 'package:get/get.dart';
import 'package:jaku/modules/note/controller/note_controllers.dart';
import 'package:jaku/modules/task/controller/task_controller.dart';

class DetailJadwalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NoteControllers());
    Get.put(TaskController());
  }
}
