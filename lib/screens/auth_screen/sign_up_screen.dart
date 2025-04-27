import 'package:flutter/material.dart';
import 'package:jaku/screens/auth_screen/sign_in_screen.dart';
import 'package:provider/provider.dart';
import '../../provider/jadwal_kuliah.dart';
import '../../provider/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  static const routeNamed = "/sign-up";

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscurePswdText = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final jadwalProvider = Provider.of<Jadwalkuliah>(context, listen: false);

    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final mediaQueryHeight = MediaQuery.of(context).size.height;

    const TextStyle titleStyle = TextStyle(fontSize: 50);
    const TextStyle subtitleStyle = TextStyle(fontSize: 18);
    const TextStyle normalText = TextStyle(fontSize: 15);

    Future<String?> signUpUser() async {
      setState(() {
        _isLoading = true;
      });

      debugPrint(
          "email: ${emailController.text}, password: ${passwordController.text}, confirm: ${confirmPassController.text}");

      try {
        if (emailController.text.trim().isEmpty ||
            passwordController.text.trim().isEmpty) {
          throw "Email dan Password tidak boleh kosong";
        } else if (confirmPassController.text.trim() !=
            passwordController.text.trim()) {
          throw "Confirm password tidak sama dengan new password";
        } else if (confirmPassController.text.trim().isEmpty) {
          throw "Confirm password tidak boleh kosong";
        } else if (confirmPassController.text.trim().length < 6) {
          throw ("password harus lebih dari 6 karakter");
        }

        await Provider.of<Auth>(context, listen: false).signUp(
            emailController.text.trim(),
            confirmPassController.text.trim(),
            jadwalProvider);

        if (!mounted) return null;

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SignIn(),
            ));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 1200),
            content: Text(
              "Sign up berhasil!",
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      } catch (error) {
        if (!mounted) return null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 1200),
            content: Text(
              (error.toString()),
              style: const TextStyle(color: Colors.black),
            ),
            backgroundColor: const Color(0xFFCF6679),
          ),
        );
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
          width: mediaQueryWidth,
          height: mediaQueryHeight,
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
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF151515),
                  borderRadius: BorderRadius.circular(20),
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
                        "Create new account",
                        textAlign: TextAlign.start,
                        style: subtitleStyle,
                      ),
                    ),
                    TextField(
                      textInputAction: TextInputAction.next,
                      controller: emailController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintStyle: normalText,
                          labelStyle: normalText,
                          prefixIcon: Icon(Icons.email_outlined),
                          hintText: "Ex: mulyono@gmail.com",
                          labelText: "Email"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      focusNode: _passwordFocus,
                      controller: passwordController,
                      obscureText: _obscurePswdText,
                      onSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(_confirmFocus),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintStyle: normalText,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePswdText = !_obscurePswdText;
                              });
                            },
                            icon: Icon(_obscurePswdText
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                          labelStyle: normalText,
                          hintText: "Ex: jokowi123",
                          labelText: "Password"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      focusNode: _confirmFocus,
                      controller: confirmPassController,
                      obscureText: _obscureConfirm,
                      onSubmitted: (value) => signUpUser(),
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintStyle: normalText,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureConfirm = !_obscureConfirm;
                              });
                            },
                            icon: Icon(_obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                          labelStyle: normalText,
                          hintText: "Ex: jokowi123",
                          labelText: "Confirm Password"),
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
                                signUpUser();
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
                                "Sign up",
                                style: TextStyle(fontSize: 15),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    const TextSpan(
                        text: "Already have an account? ", style: normalText),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SignIn.routeNamed);
                        },
                        child: const Text(
                          "Sign in",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
