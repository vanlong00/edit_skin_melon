import 'package:flutter/material.dart';

class AppErrorNoRouteWidget extends StatelessWidget {
  const AppErrorNoRouteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error"),
      ),
      body: const Center(
        child: Text(" this route wasn't found"),
      ),
    );
  }
}
