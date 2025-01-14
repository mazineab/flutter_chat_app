import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomListTile extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  const CustomListTile(
      {super.key, this.title, this.subTitle, this.leading, this.trailing,this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // enableFeedback: false,

      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            leading ?? const SizedBox(),
            const SizedBox(width: 12),
            // User Info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      title != null
                          ? Text(
                              title!,
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  subTitle != null
                      ? Column(
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              subTitle!,
                              style: GoogleFonts.nunito(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        )
                      : const SizedBox()
                ],
              ),
            ),
            trailing ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
