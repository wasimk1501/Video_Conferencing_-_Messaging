import 'package:flutter/material.dart';

class JoinWithCode extends StatefulWidget {
  const JoinWithCode({super.key});

  @override
  State<JoinWithCode> createState() => _JoinWithCodeState();
}

TextEditingController nameController = TextEditingController();
TextEditingController codeController = TextEditingController();

class _JoinWithCodeState extends State<JoinWithCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            "Your name",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          TextField(
            controller: nameController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
                alignLabelWithHint: false,
                helperText: "Name",
                hintText: "Enter your name"),
          ),
          Text(
            "Meeting code",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          TextField(
            controller: codeController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
                alignLabelWithHint: false,
                helperText: "Name",
                hintText: "Enter your name"),
          ),
        ],
      ),
    );
  }
}
