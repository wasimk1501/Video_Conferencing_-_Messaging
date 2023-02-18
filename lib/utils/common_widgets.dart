import 'package:flutter/material.dart';

const LinearGradient gradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF73AEF5),
    Color(0xFF61A4F1),
    Color(0xFF478DE0),
    Color(0xFF398AE5),
  ],
  stops: [0.1, 0.4, 0.7, 0.9],
);
const kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

const kLabelStyle = TextStyle(
    color: Colors.white, fontFamily: 'OpenSans', fontWeight: FontWeight.bold);

final kBoxDecorationStyle = BoxDecoration(
  color: const Color(0xff6ca8f1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
