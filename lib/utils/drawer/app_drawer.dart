import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/colors.dart';
import '../../common/constant.dart';
import '../../screens/forget_password_screen.dart';
import '../login_widget.dart';
import '../signup_widget.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
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
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 70.0, left: 20.0),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello,",
                    style: GoogleFonts.comfortaa(
                        fontWeight: FontWeight.bold,
                        color: TextColor.textColor,
                        fontSize: AppFont.normalFontSize),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Wasim Khan",
                    style: GoogleFonts.comfortaa(
                        fontWeight: FontWeight.bold,
                        color: TextColor.textColor,
                        fontSize: AppFont.largeFontSize),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1.0,
              color: TextColor.textColor,
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.house,
                      color: TextColor.textColor,
                    ),
                    title: Text(
                      'Home',
                      style: GoogleFonts.comfortaa(
                          fontSize: AppFont.smallFontSize,
                          color: TextColor.textColor,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      // Do something when home is tapped
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.plus,
                      color: TextColor.textColor,
                    ),
                    title: Text(
                      'Create new meeting',
                      style: GoogleFonts.comfortaa(
                          fontSize: AppFont.smallFontSize,
                          color: TextColor.textColor,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      // Do something when home is tapped
                      Navigator.pushNamed(context, "/createMeeting");
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.connect_without_contact,
                      color: TextColor.textColor,
                    ),
                    title: Text(
                      'Join with code',
                      style: GoogleFonts.comfortaa(
                          fontSize: AppFont.smallFontSize,
                          color: TextColor.textColor,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      // Do something when home is tapped
                      Navigator.pushNamed(context, "/joinMeeting");
                    },
                  ),
                  ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.rightFromBracket,
                      color: TextColor.textColor,
                    ),
                    title: Text(
                      'Logout',
                      style: GoogleFonts.comfortaa(
                          fontSize: AppFont.smallFontSize,
                          color: TextColor.textColor,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      rEmailController.clear();
                      rPasswordController.clear();
                      rConfirmPasswordController.clear();
                      lEmailController.clear();
                      lPasswordController.clear();
                      resetEmailController.clear();
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ListTile(
                      title: Center(
                        child: Text(
                          '© MeetingMinds.app All rights reserved.',
                          style: GoogleFonts.comfortaa(
                              fontSize: 10.0,
                              color: TextColor.textColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
