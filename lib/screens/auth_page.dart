import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jaku/provider/jadwal_kuliah.dart';
import 'package:get/get.dart';

import '../routes/route_named.dart';
import '../provider/auth.dart' as aut;

const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _recoverPassword(String email) async {
    debugPrint('Name: $email');
    try {
      await Get.find<aut.AuthController>().resetPassword(email);
      return null;
    } catch (error) {
      return error.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final jadwalProvider = Get.find<JadwalkuliahController>();
    final authController = Get.find<aut.AuthController>();

    Future<String?> authUser(LoginData data) {
      debugPrint('Name: ${data.name}, Password: ${data.password}');
      return Future.delayed(loginTime).then((_) async {
        try {
          await authController.signIn(data.name, data.password, jadwalProvider);
        } catch (error) {
          if (!mounted) {
            return null;
          }
          return error.toString();
        }
        return null;
      });
    }

    Future<String?> signupUser(SignupData data) {
      debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
      return Future.delayed(loginTime).then((_) async {
        try {
          await authController.signUp(
              data.name!, data.password!, jadwalProvider);
        } catch (error) {
          if (!mounted) {
            return null;
          }
          return error.toString();
        }
        return null;
      });
    }

    return FlutterLogin(
      title: 'JaKu',
      theme: LoginTheme(
          pageColorDark: const Color.fromARGB(255, 107, 107, 107),
          pageColorLight: const Color.fromARGB(255, 40, 39, 39),
          errorColor: const Color(0xFFCF6679),
          cardTheme: const CardTheme(color: Color(0xFF151515))),
      // logo: const AssetImage('assets/images/ecorp-lightblue.png'),
      onLogin: authUser,
      onSignup: signupUser,
      loginAfterSignUp: false,
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: () async {
            // debugPrint('start google sign in');
            await Future.delayed(loginTime).then(
              (value) async {
                try {
                  await authController.signInWithGoogle();
                  Get.offNamed(RouteNamed.homePage);
                } catch (e) {
                  print("error: $e");
                }
              },
            );
            // debugPrint('stop google sign in');
            return null;
          },
        ),
      ],
      onSubmitAnimationCompleted: () async {
        await jadwalProvider.getOnce();

        if (!mounted) {
          return;
        }

        Get.offNamed(RouteNamed.homePage);
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
