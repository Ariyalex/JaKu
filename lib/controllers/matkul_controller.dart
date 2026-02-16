import 'package:get/get.dart';
import 'package:jaku/core/utils/my_snackbar.dart';
import 'package:jaku/data/models/matkul.dart';
import 'package:jaku/services/matkul_service.dart';

class MatkulController extends GetxController {
  final MatkulService matkulService;
  MatkulController({required this.matkulService});

  RxList<Matkul> get matkuls => matkulService.matkuls;

  void handleRefreshMatkul() {
    try {
      matkulService.loadMatkuls();
    } catch (e) {
      MySnackbar.error(message: e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
