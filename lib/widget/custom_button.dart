import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? horizontalMargin;
  const CustomButton({super.key,required this.text,required this.onTap,this.horizontalMargin});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal:horizontalMargin ?? 30),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:WidgetStatePropertyAll(Colors.grey.withOpacity(0.4)),
              shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              )
          ),
          onPressed:onTap,
          child:Text(
              text,
              style: GoogleFonts.nunito(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
          )
      ),
    );
  }
}
