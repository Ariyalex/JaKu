import 'package:jaku/domain/datasources/matkul_local_datasource.dart';
import 'package:jaku/domain/models/matkul.dart';
import 'package:jaku/domain/repositories/matkul_repository.dart';

class MatkulRepositoryImpl extends MatkulRepository {
  final MatkulLocalDatasource localDatasource;
  MatkulRepositoryImpl({required this.localDatasource});

  @override
  List<Matkul> getAllMatkul() {
    try {
      return localDatasource.getAllMatkul();
    } catch (e) {
      print("error get all matkul(repo): $e");
      rethrow;
    }
  }

  @override
  Matkul getMatkulById(String id) {
    try {
      final result = localDatasource.getMatkulById(id);
      if (result == null) throw Exception("Matkul tidak ditemukan");
      return result;
    } catch (e) {
      print("error get matkul(repo): $e");
      rethrow;
    }
  }

  @override
  Future<void> addMatkul(Matkul matkul) async {
    try {
      await localDatasource.saveMatkul(matkul);
    } catch (e) {
      print("error save matkul(repo): $e");
      rethrow;
    }
  }

  @override
  Future<void> addMatkuls(List<Matkul> matkuls) async {
    try {
      await localDatasource.saveMatkuls(matkuls);
    } catch (e) {
      print("error save matkuls: $e");
      rethrow;
    }
  }

  @override
  Future<void> updateMatkul(Matkul matkul) async {
    try {
      final getMatkul = localDatasource.getMatkulById(matkul.id);
      if (getMatkul == null) throw Exception("Matkul tidak ditemukan");
      await localDatasource.saveMatkul(matkul);
    } catch (e) {
      print("error update matkul: $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteMatkul(String id) async {
    try {
      final getMatkul = localDatasource.getMatkulById(id);
      if (getMatkul == null) throw Exception("Matkul tidak ditemukan");
      await localDatasource.deleteMatkul(id);
    } catch (e) {
      print("error delete matkul: $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteAllMatkul() async {
    try {
      await localDatasource.deleteAllMatkul();
    } catch (e) {
      print("error delete all matkul: $e");
      rethrow;
    }
  }
}
