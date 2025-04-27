import 'package:cloud_firestore/cloud_firestore.dart';
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

//simpan data user ke firestore
      await FirebaseFirestore.instance.collection("users").doc(email).set({
        "uid": userCredential.user!.uid,
      });

      _user = userCredential.user;
      print("$email & $password");
      // jadwalKuliah.updateAuthData(_user);
      _auth.signOut();
      notifyListeners();
    } on FirebaseAuthException catch (error) {
      print(error.code);
      String errorMessage;

      switch (error.code) {
        case "invalid-email":
          errorMessage = 'Format email tidak valid';
          break;
        case "too-many-requests":
          errorMessage = "Terlalu banyak percobaan login. Coba lagi nanti.";
          break;
        case "network-request-failed":
          errorMessage = "Tidak ada koneksi internet. Periksa jaringan Anda.";
          break;
        case "email-already-in-use":
          throw "Email sudah dipakai, gunakan email yang lain";
        default:
          errorMessage = "Terjadi kesalahan saat Sign up. Silakan coba lagi.";
      }
      throw errorMessage;
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
      print("sign in berhasil");
      // jadwalKuliah.updateAuthData(_user);
      notifyListeners();
    } on FirebaseAuthException catch (error) {
      String errorMessage;
      print(error.code);

      //mapping kode error ke pesan custom
      switch (error.code) {
        case "invalid-credential":
          errorMessage = 'Email atau password yang anda masukkan salah';
          break;
        case "too-many-requests":
          errorMessage = "Terlalu banyak percobaan login. Coba lagi nanti.";
          break;
        case "network-request-failed":
          errorMessage = "Tidak ada koneksi internet. Periksa jaringan Anda.";
          break;
        case "invalid-email":
          errorMessage = "Email tidak valid";
        default:
          errorMessage = "Terjadi kesalahan saat login. Silakan coba lagi.";
      }
      throw errorMessage;
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
      //cek apa email sudah terdaftar di firebase
      var querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(email.trim())
          .get();
      if (!querySnapshot.exists) {
        throw "Email tidak terdaftar. silahkan periksa kembali";
      }

      await _auth.sendPasswordResetEmail(email: email);
      print("berhasil kirim mail");
    } on FirebaseAuthException catch (error) {
      throw error.message ??
          "Terjadi kesalahan saat mengirim email reset password.";
    } catch (error) {
      rethrow;
    }
  }
}
