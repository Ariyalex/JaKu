import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/auth_c.dart';

import '../../routes/route_named.dart';
import '../../provider/jadwal_kuliah.dart';
import '../../provider/auth.dart' as aut;

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late AuthC authC;
  bool _obscureText = true;
  bool _isLoading = false;
  bool _isLoadingGoogle = false;

  @override
  void initState() {
    super.initState();
    // Cek apakah controller sudah terdaftar
    if (!Get.isRegistered<AuthC>()) {
      authC = Get.put(AuthC());
    } else {
      // Gunakan yang sudah ada dan reset field-nya
      authC = Get.find<AuthC>();
      authC.emailC.clear();
      authC.passwordC.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final jadwalProvider = Get.find<JadwalkuliahController>();
    final authController = Get.find<aut.AuthController>();

    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final mediaQueryHeight = MediaQuery.of(context).size.height;

    const TextStyle titleStyle = TextStyle(fontSize: 50);
    const TextStyle subtitleStyle = TextStyle(fontSize: 18);
    const TextStyle normalText = TextStyle(fontSize: 15);

    Future<String?> authUser() async {
      setState(() {
        _isLoading = true;
      });

      debugPrint(
          'Name: ${authC.emailC.text}, Password: ${authC.passwordC.text}');

      try {
        //cek email or password kosong
        if (authC.emailC.text.trim().isEmpty ||
            authC.passwordC.text.trim().isEmpty) {
          throw "Email dan Password tidak boleh kosong";
        }

        await authController.signIn(
          authC.emailC.text.trim(),
          authC.passwordC.text.trim(),
          jadwalProvider,
        );

        if (!mounted) return null;
      } catch (error) {
        Get.snackbar("Error!", error.toString(),
            backgroundColor: Colors.red.shade400);
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
      return null;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: mediaQueryHeight,
          width: mediaQueryWidth,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "JaKu",
                textAlign: TextAlign.center,
                style: titleStyle,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF151515),
                ),
                width: mediaQueryWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      width: mediaQueryWidth,
                      child: const Text(
                        "Login to your Account",
                        textAlign: TextAlign.start,
                        style: subtitleStyle,
                      ),
                    ),
                    TextField(
                      controller: authC.emailC,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintStyle: normalText,
                          labelStyle: normalText,
                          prefixIcon: Icon(Icons.mail_outline),
                          hintText: "Ex: mulyono@gmail.com",
                          labelText: "Email"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: authC.passwordC,
                      obscureText: _obscureText,
                      onSubmitted: (value) => authUser(),
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintStyle: normalText,
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(_obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility)),
                          labelStyle: normalText,
                          prefixIcon: const Icon(Icons.lock_outline),
                          hintText: "Ex: jokowi123",
                          labelText: "Password"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: mediaQueryWidth,
                      height: 50,
                      child: FilledButton(
                          style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: _isLoading
                              ? null
                              : () {
                                  authUser();
                                },
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Sign in",
                                  style: TextStyle(fontSize: 17),
                                )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(RouteNamed.recoveryPass);
                      },
                      child: const Text("Forgot password?"),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Text(
                    "-Or sign in with-",
                    style: normalText,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      try {
                        setState(() {
                          _isLoadingGoogle = true;
                        });

                        await authController.signInWithGoogle();

                        if (!mounted) return;

                        Get.offNamed(RouteNamed.homePage);
                      } catch (error) {
                        Get.snackbar("Error!", error.toString(),
                            backgroundColor: Colors.red.shade400);
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoadingGoogle = false;
                          });
                        }
                      }
                    },
                    child: Container(
                      width: 75,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(7)),
                      child: _isLoadingGoogle
                          ? const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              FontAwesomeIcons.google,
                              size: 30,
                            ),
                    ),
                  ),
                ],
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    const TextSpan(
                        text: "Don't have an account? ", style: normalText),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(RouteNamed.signUpScreen);
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
