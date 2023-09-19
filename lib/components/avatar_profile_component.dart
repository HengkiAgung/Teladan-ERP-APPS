import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/Employee/User.dart';

class AvatarProfileComponent extends StatelessWidget {
  final User user;

  const AvatarProfileComponent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 36,
        bottom: 36,
      ),
      child: Row(
        children: [
          user.foto_file != ""
              ? CircleAvatar(
                  radius: 25, // Image radius
                  backgroundImage: NetworkImage(user.foto_file))
              : const CircleAvatar(
                  radius: 25, // Image radius
                  backgroundImage: AssetImage("images/profile_placeholder.jpg"),
                ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 51, 51, 51),
                ),
              ),
              Text(
                user.kontak != "" ? "+62 ${user.kontak}" : "",
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
              Text(
                user.email,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}
