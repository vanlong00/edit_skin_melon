import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimateWidgets extends StatelessWidget {
  const LoadingAnimateWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/loading_animation.json',
      frameRate: FrameRate.max,
      width: 160,
      height: 160,
    );
  }
}