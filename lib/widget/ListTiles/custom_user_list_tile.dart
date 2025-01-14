import 'package:chat_app/data/models/user.dart' as usr;
import 'package:chat_app/modules/current_user_controller.dart';
import 'package:chat_app/widget/custom_profile.dart';
import 'package:chat_app/widget/dialogs/send_message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomUserListTile extends StatelessWidget {
  final usr.User user;
  const CustomUserListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CustomProfile(path: user.profilePicture??'',picker: false),
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
            TextButton(
                onPressed: () {
                  SendMessageDialog.show(context,
                  sndrUid:Get.find<CurrentUserController>().authUser.value.docId,
                  rcvrUid: user.docId
                  );
                },
                child: const Text(
                  "Send Message",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 13),
                ))
          ],
        ),
      ),
    );
  }
}
