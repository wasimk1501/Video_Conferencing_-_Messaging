import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_conferencing/main.dart';
import 'package:video_conferencing/utils/common_widgets.dart';
import 'package:video_conferencing/utils/password_textfield.dart';
import 'package:video_conferencing/utils/utils_class.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const LoginWidget({super.key, required this.onClickedSignUp});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

bool _rememberMe = false;
TextEditingController lEmailController = TextEditingController();
TextEditingController lPasswordController = TextEditingController();

Widget _buildEmailTF() {
  return Column(
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
          controller: lEmailController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
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
            if (value!.isEmpty) return "    *Email is required";
            return null;
          },
        ),
      ),
    ],
  );
}

class _LoginWidgetState extends State<LoginWidget> {
  Widget _buildForgotPasswordBtn() {
    return Container(
      padding: const EdgeInsets.only(right: 0.0),
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, "/forgetPassword"),
        child: const Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return SizedBox(
      height: 20.0,
      child: Row(children: <Widget>[
        Theme(
          data: ThemeData(unselectedWidgetColor: Colors.white),
          child: Checkbox(
            value: _rememberMe,
            checkColor: Colors.green,
            activeColor: Colors.white,
            onChanged: (value) {
              setState(() {
                _rememberMe = value!;
                log(_rememberMe.toString());
              });
            },
          ),
        ),
        const Text(
          'Remember me',
          style: kLabelStyle,
        ),
      ]),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
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

          signIn();
        },
        child: const Text('Login',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            )),
      ),
    );
  }

  Widget dontHaveAccount() {
    return GestureDetector(
      // onTap: () => Navigator.pushReplacementNamed(context, "/signUp"),
      child: RichText(
          text: TextSpan(children: [
        const TextSpan(
          text: 'Don\'t have an Account? ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextSpan(
            text: 'Sign Up',
            recognizer: TapGestureRecognizer()..onTap = widget.onClickedSignUp,
            style: const TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white))
      ])),
    );
  }

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: lEmailController.text.trim(),
          password: lPasswordController.text.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'unknown') {
        Utils.showSnackbar("*Both fields are required");
      } else if (e.code == 'network-request-failed') {
        Utils.showSnackbar("Check your internet connection");
      } else if (e.code == 'user-not-found') {
        Utils.showSnackbar("User not found");
      } else if (e.code == 'invalid-email') {
        Utils.showSnackbar("Email is badly formatted");
      } else if (e.code == 'wrong-password') {
        Utils.showSnackbar("Invalid Password");
      } else {
        Utils.showSnackbar(e.toString());
      }
    }
    //Navigator.of(context) not working
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    // lEmailController.clear();
    // lPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: gradient,
          ),
        ),
        Container(
          height: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
                left: 40.0, right: 40.0, top: 80.0, bottom: 40.0),
            physics: const AlwaysScrollableScrollPhysics(),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text(
                "Sign In",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 30),
              _buildEmailTF(),
              const SizedBox(
                height: 30.0,
              ),
              PasswordTextField(),
              _buildForgotPasswordBtn(),
              const SizedBox(
                height: 0.0,
              ),
              _buildRememberMeCheckbox(),
              _buildLoginBtn(),
              SizedBox(
                  height: 250.0,
                  child: Lottie.asset("assets/lottie/login_lottie.json")),
              dontHaveAccount(),
            ]),
          ),
        )
      ],
    );
  }
}
