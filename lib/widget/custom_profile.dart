import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomProfile extends StatelessWidget {
  final String path;
  final bool picker;
  const CustomProfile({super.key, required this.path, this.picker = true});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width:picker? 120:56,
        height: picker? 120:56,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(100),
          image: path.isNotEmpty
              ? (!path.startsWith('https')
                ? DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover)
                : DecorationImage(image: CachedNetworkImageProvider(path),fit: BoxFit.cover))
              : null,
        ),
        child: picker && path.isEmpty
            ? const Icon(Icons.photo, size: 50, color: Colors.white)
            : (path.isEmpty
            ? ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Image.asset(
            'assets/images/user_placeholder.png',
            fit: BoxFit.cover,
          ),
        )
            : Container()),
      ),
    );
  }
}
