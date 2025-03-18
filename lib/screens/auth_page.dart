import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jaku/provider/jadwal_kuliah.dart';
import 'package:provider/provider.dart';
import './home_screen.dart';
import '../provider/auth.dart' as aut;

const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = "/auth-page";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _recoverPassword(String email) async {
    debugPrint('Name: $email');
    try {
      await Provider.of<aut.Auth>(context, listen: false).resetPassword(email);
      return null;
    } catch (error) {
      return error.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final jadwalProvider = Provider.of<Jadwalkuliah>(context, listen: false);

    Future<String?> authUser(LoginData data) {
      debugPrint('Name: ${data.name}, Password: ${data.password}');
      return Future.delayed(loginTime).then((_) async {
        try {
          await Provider.of<aut.Auth>(context, listen: false)
              .signIn(data.name, data.password, jadwalProvider);
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
          await Provider.of<aut.Auth>(context, listen: false)
              .signUp(data.name!, data.password!, jadwalProvider);
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
          pageColorDark: Color.fromARGB(255, 107, 107, 107),
          pageColorLight: Color.fromARGB(255, 40, 39, 39),
          errorColor: Color(0xFFCF6679),
          cardTheme: CardTheme(color: Color(0xFF151515))),
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
                  await Provider.of<aut.Auth>(context, listen: false)
                      .signInWithGoogle();
                  Navigator.pushReplacementNamed(context, HomeScreen.routeName);
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
        await Provider.of<Jadwalkuliah>(context, listen: false).getOnce();

        if (!mounted) {
          return;
        }

        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
