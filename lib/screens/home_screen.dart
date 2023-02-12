import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Column(
        children: [
          Container(child: const Text("Create a new meeting.")),
          Container(child: Text("Enter the code")),
        ],
      ),
    );
  }
}
