import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget mainWidget;
  const CustomContainer({super.key, required this.mainWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        // height: 80,
        decoration: BoxDecoration(
            color: const Color(0xFF555555).withOpacity(0.18),
            borderRadius: BorderRadius.circular(15)),
      child: mainWidget,
    );
  }
}
