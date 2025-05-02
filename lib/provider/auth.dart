import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jaku/provider/jadwal_kuliah.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final Rxn<User> _user = Rxn<User>();

  User? get user => _user.value;

  bool get isLoggedIn => _user.value != null;

  // Flag untuk melacak apakah inisialisasi sudah selesai
  final RxBool _initialized = false.obs;
  @override
  bool get initialized => _initialized.value;

  // Metode untuk inisialisasi auth yang dipanggil dari main.dart
  Future<void> initializeAuth() async {
    try {
      // Periksa dulu apakah user sudah login di Firebase
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        _user.value = currentUser;
        print("Auth initialized with user: ${currentUser.uid}");

        // Pastikan user ID disimpan di SharedPreferences
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setBool("hasLoggedIn", true);
        await pref.setString("userId", currentUser.uid);

        // Update ID di controller jadwal
        Get.find<JadwalkuliahController>().updateAuthData(currentUser);
      } else {
        // Jika tidak ada user di Firebase, coba load dari SharedPreferences
        await loadUserFromPreferences();
      }

      // Subscribe to auth state changes untuk selanjutnya
      _auth.authStateChanges().listen((User? firebaseUser) {
        if (firebaseUser != null &&
            (_user.value == null || _user.value?.uid != firebaseUser.uid)) {
          _user.value = firebaseUser;
          print("Auth state changed: user = ${firebaseUser.uid}");

          // Simpan user ID ke SharedPreferences setiap kali auth state berubah
          _saveUserToPreferences(firebaseUser);

          // Update jadwal controller
          Get.find<JadwalkuliahController>().updateAuthData(firebaseUser);
        } else if (firebaseUser == null && _user.value != null) {
          _user.value = null;
          print("Auth state changed: user logged out");
        }
      });

      // Tandai inisialisasi selesai
      _initialized.value = true;
    } catch (e) {
      print("Error initializing auth: $e");
      _initialized.value = true; // Tandai selesai meskipun error
    }
  }

  // Helper method untuk menyimpan user ke preferences
  Future<void> _saveUserToPreferences(User user) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("hasLoggedIn", true);
      await pref.setString("userId", user.uid);
      print("User saved to preferences: ${user.uid}");
    } catch (e) {
      print("Error saving user to preferences: $e");
    }
  }


  Future<void> loadUserFromPreferences() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      bool hasLoggedIn = pref.getBool("hasLoggedIn") ?? false;
      String? userId = pref.getString("userId");

      if (hasLoggedIn && userId != null) {
        // If Firebase auth already has the user, just make sure controllers are updated
        if (_auth.currentUser != null) {
          _user.value = _auth.currentUser;
          // Update the user ID in JadwalkuliahController
          Get.find<JadwalkuliahController>().updateAuthData(_user.value);
          print("User loaded from Firebase Auth: ${_user.value?.uid}");
        }
        // If no Firebase auth but we have userId in preferences, try to recover the session
        else {
          print("Trying to recover session for userId: $userId");
          // You could implement additional recovery logic here if needed
        }
      } else {
        print("No logged in user found in preferences");
      }
    } catch (e) {
      print("Error loading user from preferences: $e");
    }
  }

  Future<void> signUp(String email, String password,
      JadwalkuliahController jadwalKuliah) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

//simpan data user ke firestore
      await FirebaseFirestore.instance.collection("users").doc(email).set({
        "uid": userCredential.user!.uid,
      });

      _user.value = userCredential.user;
      // jadwalKuliah.updateAuthData(_user);
      _user.value = userCredential.user;
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
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

  Future<void> signIn(String email, String password,
      JadwalkuliahController jadwalKuliah) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      _user.value = userCredential.user;

      // Update user ID in jadwalKuliah controller
      jadwalKuliah.updateAuthData(_user.value);

      // Save user information to SharedPreferences
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("hasLoggedIn", true);
      if (_user.value != null) {
        await pref.setString("userId", _user.value!.uid);
        print("User ID saved to preferences: ${_user.value!.uid}");
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage;

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
      _user.value = userCredential.user;

      if (_user.value != null) {
        // Update user ID in jadwalKuliah controller
        Get.find<JadwalkuliahController>().updateAuthData(_user.value);

        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("userId", _user.value!.uid);
      }
    } catch (error) {
      throw "Gagal login dengan google: $error";
    }
  }

  Future<void> signOut(JadwalkuliahController jadwalKuliah) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      _user.value = null;

      await jadwalKuliah.cancelSubscription();
      jadwalKuliah.clearData();
      jadwalKuliah.updateAuthData(null);

      // Clear all auth-related preferences
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("hasLoggedIn", false);
      await pref.remove("userId");
      print("User logged out and preferences cleared");
    } catch (error, stackTrace) {
      debugPrint("error saat logout: $error");
      debugPrint("stacktrace: $stackTrace");
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
    } on FirebaseAuthException catch (error) {
      throw error.message ??
          "Terjadi kesalahan saat mengirim email reset password.";
    } catch (error) {
      rethrow;
    }
  }
}
