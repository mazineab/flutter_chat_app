import 'dart:io';
import 'package:flutter/material.dart';

class CustomProfile extends StatelessWidget {
  final File? file;
  const CustomProfile({super.key, this.file});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(100),
          image: file != null
              ? DecorationImage(image: FileImage(file!),fit: BoxFit.cover)
              : null,
        ),
        child: file == null
            ? const Icon(Icons.photo, size: 50, color: Colors.white)
            : null,
      ),
    );
  }
}
