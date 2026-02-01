import 'package:jaku/domain/models/matkul.dart';

abstract class MatkulLocalDatasource {
  List<Matkul> getAllMatkul();
  Matkul? getMatkulById(String id);
  Future<void> saveMatkul(Matkul matkul);
  Future<void> saveMatkuls(List<Matkul> matkuls);
  Future<void> deleteMatkul(String id);
  Future<void> deleteAllMatkul();
}
