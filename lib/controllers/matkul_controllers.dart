import 'package:get/get.dart';
import 'package:jaku/models/matkul.dart';
import 'package:jaku/services/matkul_service.dart';

class MatkulController extends GetxController {
  final RxList<Matkul> allMatkul = <Matkul>[].obs;

  Matkul? selectMatkulById(String id) {
    return allMatkul.firstWhere(
      (element) => element.id == id,
      orElse: () => throw Exception("Matkul degnan ID $id tidak ditemaukan"),
    );
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // Load matkul
    List<Matkul> matkulData = MatkulService.getAllMatkulService();
    allMatkul.clear();
    allMatkul.addAll(matkulData);
  }
}
