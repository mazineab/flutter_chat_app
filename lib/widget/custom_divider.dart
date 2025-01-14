import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final Color? color;
  const CustomDivider({super.key,this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Divider(color:color?? Colors.grey.withOpacity(0.1),height: 1)
    );
  }
}
