import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../provider/auth.dart' as aut;

class RecoveryPass extends StatefulWidget {
  const RecoveryPass({super.key});

  @override
  State<RecoveryPass> createState() => _RecoveryPassState();
}

class _RecoveryPassState extends State<RecoveryPass> {
  bool _isLoading = false;

  Future<String?> _recoverPassword(String email) async {
    setState(() {
      _isLoading = true;
    });

    debugPrint('Name: $email');
    try {
      if (recoveryController.text.isEmpty) {
        throw "Email recovery harus diisi!";
      }

      await Get.find<aut.AuthController>().resetPassword(email);

      Get.back();
      Get.snackbar("Success", "Mail telah dikirm ke email!",
          backgroundColor: Colors.green.shade400);
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

  final TextEditingController recoveryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final mediaQueryHeight = MediaQuery.of(context).size.height;

    const TextStyle titleStyle = TextStyle(fontSize: 50);
    const TextStyle subtitleStyle = TextStyle(fontSize: 18);
    const TextStyle normalText = TextStyle(fontSize: 15);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: mediaQueryHeight,
          width: mediaQueryWidth,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
                        "Reset your password",
                        textAlign: TextAlign.start,
                        style: subtitleStyle,
                      ),
                    ),
                    TextField(
                      controller: recoveryController,
                      onSubmitted: (value) => _recoverPassword,
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
                      height: 10,
                    ),
                    const Text(
                      "We will send you email to reset your password,\nemail contains link to reset your password.\nDont reply this mail.",
                      textAlign: TextAlign.center,
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
                                  _recoverPassword(
                                      recoveryController.text.trim());
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
                                  "Recover",
                                  style: TextStyle(fontSize: 17),
                                )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: mediaQueryWidth,
                      height: 50,
                      child: OutlinedButton(
                        style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          "Back",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
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
