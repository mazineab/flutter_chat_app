import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const CustomButton({super.key,required this.text,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:const WidgetStatePropertyAll(Colors.grey),
              shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
              )
          ),
          onPressed:onTap,
          child:Text(text)
      ),
    );;
  }
}
