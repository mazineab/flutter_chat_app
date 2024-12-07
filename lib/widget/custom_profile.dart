import 'package:flutter/material.dart';

class CustomProfile extends StatelessWidget {
  const CustomProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(Icons.photo,size: 50,color: Colors.white,),
      ),
    );
  }
}
