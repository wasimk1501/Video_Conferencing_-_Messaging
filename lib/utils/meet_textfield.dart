import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_conferencing/common/constant.dart';

import '../common/colors.dart';

class MeetTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final bool? readOnly;
  final String? hintText;
  final TextInputType? keyboardType;
  const MeetTextfield({
    super.key,
    required this.controller,
    required this.name,
    this.hintText,
    this.readOnly,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 5.0),
          child: Text(
            name,
            style: GoogleFonts.comfortaa(
              fontSize: AppFont.normalFontSize,
              color: TextColor.textColor,
            ),
          ),
        ),
        Container(
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
          child: TextField(
            style: GoogleFonts.comfortaa(
                color: Colors.blue, fontSize: AppFont.normalFontSize),
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly!,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
                border: InputBorder.none,
                // OutlineInputBorder(
                //     borderRadius:
                //         BorderRadius.all(Radius.circular(20.0))),
                alignLabelWithHint: false,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
                hintText: hintText,
                hintStyle: const TextStyle(
                    color: TextColor.textColor,
                    fontSize: AppFont.smallFontSize)),
          ),
        ),
      ],
    );
  }
}
