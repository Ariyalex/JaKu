import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jaku/provider/jadwal_kuliah.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;

  User? get user => _user;

  bool get isLoggedIn => _user != null;

  Future<void> checkLoginStatus() async {
    _user = _auth.currentUser;

    SharedPreferences pref = await SharedPreferences.getInstance();
    bool hasLoggedIn = pref.getBool("hasLoggedIn") ?? false;

    if (_user != null && hasLoggedIn) {
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> signUp(
      String email, String password, Jadwalkuliah jadwalKuliah) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      _user = userCredential.user;
      // jadwalKuliah.updateAuthData(_user);
      notifyListeners();
    } on FirebaseAuthException catch (error) {
      throw error.message ?? "Terjadi kesalahan saat mendaftar";
    } catch (error) {
      throw ("Terjadi kesalahan yang tidak diketahui.");
    }
  }

  Future<void> signIn(
      String email, String password, Jadwalkuliah jadwalKuliah) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      _user = userCredential.user;
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("hasLoggedIn", true);

      // jadwalKuliah.updateAuthData(_user);
      notifyListeners();
    } on FirebaseAuthException catch (error) {
      throw error.message ?? "Terjadi kesalahan saat login";
    } catch (error) {
      throw ("Terjadi kesalahan yang tidak diketahui.");
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw "login dibatalkan pengguna";
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      _user = userCredential.user;

      if (_user != null) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("userId", _user!.uid);
      }
      notifyListeners();
    } catch (error) {
      throw "Gagal login dengan google: $error";
    }
  }

  Future<void> signOut(Jadwalkuliah jadwalKuliah) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      _user = null;

      await jadwalKuliah.cancelSubscription();
      jadwalKuliah.clearData();
      jadwalKuliah.updateAuthData(null);

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("hasLoggedIn", false);

      notifyListeners();
    } catch (error, stackTrace) {
      print("error saat logout: $error");
      print("stacktrace: $stackTrace");
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      throw error.message ??
          "Terjadi kesalahan saat mengirim email reset password.";
    } catch (error) {
      throw "Terjadi kesalahan yang tidak diketahui.";
    }
  }
}
