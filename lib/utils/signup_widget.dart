import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lottie/lottie.dart';
import 'package:video_conferencing/main.dart';
import 'package:video_conferencing/utils/common_widgets.dart';
import 'package:video_conferencing/utils/utils_class.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback onClickedLogin;
  const SignUpWidget({super.key, required this.onClickedLogin});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

final formKey = GlobalKey<FormState>();

TextEditingController rEmailController = TextEditingController();
TextEditingController rPasswordController = TextEditingController();
TextEditingController rConfirmPasswordController = TextEditingController();

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
          controller: rEmailController,
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value!.isEmpty) {
              return "    *Email is required";
            } else if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                .hasMatch(value)) {
              return "    *Invalid email address";
            }
            // else if (EmailValidator.validate(value)) {
            //   return "Enter the valid email";
            // }
          },
        ),
      ),
    ],
  );
}

Widget _buildPasswordTF() {
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: '    *Password is required'),
    MinLengthValidator(8,
        errorText: '    *Password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: '    *Passwords must have at least one special character')
  ]);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        "Password",
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
          controller: rPasswordController,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: true,
          style: const TextStyle(
            fontFamily: 'OpenSans',
            color: Colors.white,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0),
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.white,
            ),
            hintText: "Enter your Password",
            errorStyle: TextStyle(color: Colors.red),
            hintStyle: kHintTextStyle,
          ),
          validator: passwordValidator,
        ),
      ),
    ],
  );
}

Widget _buildConfirmPasswordTF() {
  String? confirmPassword;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        "Confirm Password",
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
          controller: rConfirmPasswordController,
          textInputAction: TextInputAction.done,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: true,
          style: const TextStyle(
            fontFamily: 'OpenSans',
            color: Colors.white,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0),
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.white,
            ),
            hintText: "Confirm your password",
            errorStyle: TextStyle(color: Colors.red),
            hintStyle: kHintTextStyle,
          ),
          validator: (value) => MatchValidator(
                  errorText: "     *Passwords don't match. Please try again")
              .validateMatch(value!, rPasswordController.text),
        ),
      ),
    ],
  );
}

class _SignUpWidgetState extends State<SignUpWidget> {
  Widget _buildRegisterBtn() {
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

          signUp();
        },
        child: const Text('Register',
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

  Widget haveAccount() {
    return GestureDetector(
      // onTap: () => Navigator.pushReplacementNamed(context, "/signUp"),
      child: RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign In',
              recognizer: TapGestureRecognizer()..onTap = widget.onClickedLogin,
              style: const TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   rEmailController.dispose();
  //   rPasswordController.dispose();
  //   super.dispose();
  // }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: rEmailController.text.trim(),
          password: rPasswordController.text.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Utils.showSnackbar("The account already exists for that email");
      } else if (e.code == 'network-request-failed') {
        Utils.showSnackbar("Check your internet connection");
      } else if (e.code == 'invalid-email') {
        Utils.showSnackbar("Email is badly formatted");
      } else {
        Utils.showSnackbar(e.toString());
      }
    }

    //Navigator.of(context) not working
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
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
        Form(
          key: formKey,
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 80.0, bottom: 40.0),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    _buildEmailTF(),
                    const SizedBox(
                      height: 15.0,
                    ),
                    _buildPasswordTF(),
                    const SizedBox(
                      height: 15.0,
                    ),
                    _buildConfirmPasswordTF(),
                    _buildRegisterBtn(),
                    Container(
                        height: 250.0,
                        child: Lottie.asset("assets/lottie/login_lottie.json")),
                    haveAccount(),
                  ]),
            ),
          ),
        )
      ],
    );
  }
}
