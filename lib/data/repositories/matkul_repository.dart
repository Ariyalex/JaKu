import 'package:jaku/data/providers/local_matkul_provider.dart';
import 'package:jaku/data/entities/matkul.dart';

class MatkulRepository {
  final LocalMatkulProvider _localProvider;
  MatkulRepository(this._localProvider);

  List<Matkul> getAllMatkul() {
    try {
      return _localProvider.getAllMatkul();
    } catch (e) {
      print("error get all matkul(repo): $e");
      rethrow;
    }
  }

  Matkul getMatkulById(String id) {
    try {
      final result = _localProvider.getMatkulById(id);
      if (result == null) throw Exception("Matkul tidak ditemukan");
      return result;
    } catch (e) {
      print("error get matkul(repo): $e");
      rethrow;
    }
  }

  Future<void> addMatkul(Matkul matkul) async {
    try {
      await _localProvider.saveMatkul(matkul);
    } catch (e) {
      print("error save matkul(repo): $e");
      rethrow;
    }
  }

  Future<void> addMatkuls(List<Matkul> matkuls) async {
    try {
      await _localProvider.saveMatkuls(matkuls);
    } catch (e) {
      print("error save matkuls: $e");
      rethrow;
    }
  }

  Future<void> updateMatkul(Matkul matkul) async {
    try {
      final getMatkul = _localProvider.getMatkulById(matkul.id);
      if (getMatkul == null) throw Exception("Matkul tidak ditemukan");
      await _localProvider.saveMatkul(matkul);
    } catch (e) {
      print("error update matkul: $e");
      rethrow;
    }
  }

  Future<void> deleteMatkul(String id) async {
    try {
      final getMatkul = _localProvider.getMatkulById(id);
      if (getMatkul == null) throw Exception("Matkul tidak ditemukan");
      await _localProvider.deleteMatkul(id);
    } catch (e) {
      print("error delete matkul: $e");
      rethrow;
    }
  }

  Future<void> deleteAllMatkul() async {
    try {
      await _localProvider.deleteAllMatkul();
    } catch (e) {
      print("error delete all matkul: $e");
      rethrow;
    }
  }
}
