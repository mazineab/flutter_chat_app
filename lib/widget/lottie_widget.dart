import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieWidget extends StatelessWidget {
  final String animationPath;
  final String message;
  const LottieWidget({super.key,required this.animationPath,required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(animationPath),
        Text(message,style: const TextStyle(color: Colors.white,fontSize: 18),)
      ],
    );
  }
}
