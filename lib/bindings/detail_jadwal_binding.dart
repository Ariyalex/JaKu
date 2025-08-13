import 'package:get/get.dart';
import 'package:jaku/controllers/note_controllers/note_controllers.dart';

class DetailJadwalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NoteControllers());
  }
}
