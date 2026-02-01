import 'package:hive_flutter/hive_flutter.dart';
import 'package:jaku/data/services/storage_service.dart';
import 'package:jaku/domain/datasources/matkul_local_datasource.dart';
import 'package:jaku/domain/models/matkul.dart';

class MatkulLocalDatasourceImpl extends MatkulLocalDatasource {
  final StorageService storageService;
  MatkulLocalDatasourceImpl({required this.storageService});

  Box<Matkul> get _box => storageService.matkulBox;

  @override
  List<Matkul> getAllMatkul() {
    try {
      return _box.values.toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveMatkul(Matkul matkul) async {
    try {
      await _box.put(matkul.id, matkul);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveMatkuls(List<Matkul> matkuls) async {
    try {
      for (var matkul in matkuls) {
        await _box.put(matkul.id, matkul);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAllMatkul() async {
    try {
      await _box.clear();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteMatkul(String id) async {
    try {
      await _box.delete(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Matkul? getMatkulById(String id) {
    try {
      return _box.get(id);
    } catch (e) {
      rethrow;
    }
  }
}
