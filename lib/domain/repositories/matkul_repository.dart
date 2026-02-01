import 'package:jaku/domain/models/matkul.dart';

abstract class MatkulRepository {
  List<Matkul> getAllMatkul();
  Matkul getMatkulById(String id);
  Future<void> addMatkul(Matkul matkul);
  Future<void> addMatkuls(List<Matkul> matkuls);
  Future<void> updateMatkul(Matkul matkul);
  Future<void> deleteMatkul(String id);
  Future<void> deleteAllMatkul();
}
