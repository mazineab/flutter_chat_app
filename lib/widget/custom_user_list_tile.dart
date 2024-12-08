import 'package:chat_app/data/models/user.dart' as usr;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomUserListTile extends StatelessWidget {
  final usr.User user;
  const CustomUserListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.asset(
                  'assets/images/user_placeholder.png',
                  fit: BoxFit.cover,
                ),
              )
            ),
            const SizedBox(width: 12),
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${user.name} ${user.lastName}",
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            TextButton(onPressed: (){}, child: const Text("Send Invitation",style: TextStyle(color: Colors.blueAccent),))
          ],
        ),
      ),
    );;
  }
}
