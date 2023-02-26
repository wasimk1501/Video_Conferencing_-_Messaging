import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:video_conferencing/common/constant.dart';

import '../common/colors.dart';

class JoiningOption extends StatelessWidget {
  final String optionName;
  final IconData optionIcon;
  const JoiningOption({
    super.key,
    required this.optionName,
    required this.optionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 80.0,
          height: 80.0,
          decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: NeomorphicColor.lightShadow,
                  blurRadius: 20.0,
                  offset: Offset(-10, -10),
                  inset: true,
                ),
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 8.0,
                  offset: Offset(10, 10),
                  inset: true,
                ),
              ],
              color: NeomorphicColor.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: Icon(
            optionIcon,
            size: 30.0,
            color: Colors.blue,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            optionName,
            style: const TextStyle(
              fontSize: AppFont.smallFontSize,
              color: TextColor.textColor,
            ),
          ),
        ),
      ],
    );
  }
}
