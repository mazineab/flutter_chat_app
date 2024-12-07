import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Donthavewidget extends StatelessWidget {
  final String text;
  final String spanText;
  final VoidCallback voidCallback;
  const Donthavewidget({super.key, required this.text, required this.spanText, required this.voidCallback});

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap:voidCallback,
        child: Center(
          child: RichText(
            text: TextSpan(
              text: text,
              style: GoogleFonts.nunito(color: Colors.grey),
              children: [
                TextSpan(
                  text: spanText,
                  style: GoogleFonts.nunito(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
