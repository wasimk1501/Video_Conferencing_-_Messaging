// import 'package:flutter/material.dart';
// import 'package:video_conferencing/common/colors.dart';
// import 'package:video_conferencing/screens/home_screen.dart';
// import 'package:video_conferencing/utils/drawer/app_drawer.dart';

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   late double xOffset;
//   late double yOffset;
//   late double scaleFactor;
//   @override
//   void initState() {
//     super.initState();
//     openDrawer();
//   }

//   void closeDrawer() => setState(() {
//         xOffset = 0;
//         yOffset = 0;
//         scaleFactor = 1;
//       });
//   void openDrawer() => setState(() {
//         xOffset = 250;
//         yOffset = 150;
//         scaleFactor = 0.6;
//       });
//   @override
//   Widget build(BuildContext context) {
//     final double xOffset = 250;
//     final double yOffset = 150;
//     final double scaleFactor = 0.6;
//     return Scaffold(
//       backgroundColor: NeomorphicColor.primaryColor,
//       body: Stack(children: [
//         AppDrawer(),
//         Container(
//             transform: Matrix4.translationValues(xOffset, yOffset, 0)
//               ..scale(scaleFactor),
//             child: const HomeScreen()),
//       ]),
//     );
//   }
// }
