import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_conferencing/utils/common_widgets.dart';
import 'package:video_conferencing/utils/utils_class.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

TextEditingController resetEmailController = TextEditingController();

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(gradient: gradient),
        ),
        SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
                left: 40.0, right: 40.0, top: 80.0, bottom: 40.0),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Receive an email to reset your password 🔐",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Email",
                      style: kLabelStyle,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle,
                      height: 70.0,
                      child: TextFormField(
                        controller: resetEmailController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: const TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          hintText: "Enter your Email",
                          hintStyle: kHintTextStyle,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "    *Email is required";
                          } else if (!RegExp(
                                  r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                              .hasMatch(value)) {
                            return "    *Invalid email address";
                          }
                          return null;
                          // else if (EmailValidator.validate(value)) {
                          //   return "Enter the valid email";
                          // }
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 15.0),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(double.infinity, 55.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          // Navigator.pushNamed(context, "/home");
                          resetPassword();
                        },
                        child: const Text('Reset Password',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                            )),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Lottie.asset("assets/lottie/login_lottie.json",
                          height: 300.0),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: resetEmailController.text.trim());
      Utils.showSnackbar("✉️ Password reset email sent");
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'unknown') {
        Utils.showSnackbar("*Email is required ");
        Navigator.of(context).pop;
      } else if (e.code == 'network-request-failed') {
        Utils.showSnackbar("Check your internet connection");
        Navigator.of(context).pop;
      } else if (e.code == 'user-not-found') {
        Utils.showSnackbar("User not found");
        Navigator.of(context).pop;
      } else if (e.code == 'invalid-email') {
        Utils.showSnackbar("Email is badly formatted");
        Navigator.of(context).pop;
      } else {
        Utils.showSnackbar(e.toString());
        Navigator.of(context).pop;
      }
    }
  }
}
