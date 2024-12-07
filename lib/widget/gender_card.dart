import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/models/enums/sexe.dart';

class GenderCard extends StatelessWidget {
  final Sexe groupValue; // Sexe type for groupValue
  final Sexe value; // Sexe type for value
  final Function(Sexe) onChanged;

  const GenderCard({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(91, 158, 158, 158)),
        borderRadius: BorderRadius.circular(5),
        color: value.value != 'male'
            ? const Color.fromARGB(255, 255, 0, 170).withOpacity(0.3)
            : Colors.lightBlueAccent.withOpacity(0.3),
      ),
      child: RadioListTile<Sexe>(
        activeColor: Colors.white,
        visualDensity: const VisualDensity(horizontal: -4),
        title: Text(value.name, style: GoogleFonts.nunito(color: Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
        value: value,
        groupValue: groupValue,
        onChanged: (selectedValue) {
          if (selectedValue != null) {
            onChanged(selectedValue);
          }
        },
      ),
    );
  }
}
