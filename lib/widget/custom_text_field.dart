import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final GlobalKey<FormFieldState<String>>? textFormFieldKey;
  final String? Function(String?)? validation;
  final IconData iconPrefix;
  final VoidCallback? onTap;
  final bool readOnly;
  final int maxLines;
  const CustomTextField(
      {super.key, required this.label, required this.controller,required this.textFormFieldKey,
      this.validation,this.isPassword=false,required this.iconPrefix,this.onTap,this.readOnly=false,this.maxLines=1
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: textFormFieldKey,
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(
        color: Colors.white
      ),
      maxLines: maxLines,
      decoration: InputDecoration(
          prefixIcon: Icon(iconPrefix,color: Colors.white,size: 20,),
          enabledBorder: borderConfig(color:Colors.white),
          focusedBorder: borderConfig(color:Colors.white),
          errorBorder: borderConfig(color: Colors.red),
          focusedErrorBorder: borderConfig(color: Colors.red),
          hintText: label,
          hintStyle: GoogleFonts.nunito(
              color: Colors.blueGrey
          )),
      onChanged: (val){
        if(val.length>4) {
          textFormFieldKey?.currentState!.validate();
        }
      },
      readOnly: readOnly,
      onTap: onTap,
      validator:validation,
    );
  }

  OutlineInputBorder borderConfig({required Color color}){
    return OutlineInputBorder(
        borderSide: BorderSide(color: color.withOpacity(0.5), width: 0.8),
    borderRadius: BorderRadius.circular(8)
    );
  }
}
