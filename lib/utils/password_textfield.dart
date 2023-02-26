import 'package:flutter/material.dart';
import 'package:video_conferencing/utils/common_widgets.dart';
import 'package:video_conferencing/utils/login_widget.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({super.key});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isPassVisible = false;
  @override
  Widget build(BuildContext context) {
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
            controller: lPasswordController,
            textInputAction: TextInputAction.done,
            obscureText: isPassVisible ? false : true,
            style: const TextStyle(
              fontFamily: 'OpenSans',
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
              suffixIcon: isPassVisible
                  ? IconButton(
                      icon: const Icon(
                        Icons.visibility_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () => setState(() {
                        isPassVisible = !isPassVisible;
                      }),
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.visibility_off_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () => setState(() {
                        isPassVisible = !isPassVisible;
                      }),
                    ),
              hintText: "Enter your Password",
              hintStyle: kHintTextStyle,
            ),
            validator: (value) {
              if (value!.isEmpty) return "    *Password is required";
              return null;
            },
          ),
        ),
      ],
    );
  }
}
