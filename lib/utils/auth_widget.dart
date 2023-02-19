import 'package:flutter/material.dart';
import 'package:video_conferencing/utils/login_widget.dart';
import 'package:video_conferencing/utils/signup_widget.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

bool isLogin = true;

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(onClickedSignUp: toggle)
      : SignUpWidget(onClickedLogin: toggle);
  void toggle() => setState(() => isLogin = !isLogin);
}
