import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_conferencing/main.dart';
import 'package:video_conferencing/screens/home_screen.dart';
import 'package:video_conferencing/utils/common_widgets.dart';

class LoginScreen extends StatefulWidget {
  // final VoidCallback onClickedSignUp;
  const LoginScreen({
    Key? key,
    // required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
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
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
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
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: lPasswordController,
            textInputAction: TextInputAction.done,
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
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      padding: EdgeInsets.only(right: 0.0),
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20,
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
                print(_rememberMe);
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
      onTap: () => Navigator.pushReplacementNamed(context, "/signUp"),
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
            // recognizer: TapGestureRecognizer()..onTap = widget.onClickedSignUp,
            style: const TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white))
      ])),
    );
  }

  @override
  void dispose() {
    lEmailController.dispose();
    lPasswordController.dispose();
    super.dispose();
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
      print(e);
    }
    //Navigator.of(context) not working
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong..."),
          );
        } else if (snapshot.hasData) {
          return const HomeScreen();
        } else {
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                        _buildPasswordTF(),
                        const SizedBox(
                          height: 30.0,
                        ),
                        _buildRememberMeCheckbox(),
                        _buildLoginBtn(),
                        Container(
                            height: 300.0,
                            child: Lottie.asset(
                                "assets/lottie/login_lottie.json")),
                        dontHaveAccount(),
                      ]),
                ),
              )
            ],
          );
        }
      }),
    ));
  }
}
