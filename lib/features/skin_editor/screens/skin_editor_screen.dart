import 'package:flutter/material.dart';

class SkinEditorScreen extends StatelessWidget {
  const SkinEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Skin Editor"),
      ),
      body: const Center(
        child: Text("Skin Editor Screen"),
      ),
    );
  }
}
