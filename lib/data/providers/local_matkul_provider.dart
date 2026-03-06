import 'package:hive_flutter/hive_flutter.dart';
import 'package:jaku/data/entities/matkul.dart';

class LocalMatkulProvider {
  Box<Matkul> get _matkulBox => Hive.box<Matkul>("matkulBox");

  List<Matkul> getAllMatkul() {
    try {
      return _matkulBox.values.toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveMatkul(Matkul matkul) async {
    try {
      await _matkulBox.put(matkul.id, matkul);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveMatkuls(List<Matkul> matkuls) async {
    try {
      for (var matkul in matkuls) {
        await _matkulBox.put(matkul.id, matkul);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAllMatkul() async {
    try {
      await _matkulBox.clear();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMatkul(String id) async {
    try {
      await _matkulBox.delete(id);
    } catch (e) {
      rethrow;
    }
  }

  Matkul? getMatkulById(String id) {
    try {
      return _matkulBox.get(id);
    } catch (e) {
      rethrow;
    }
  }
}
