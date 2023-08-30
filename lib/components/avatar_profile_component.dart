import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/Employee/User.dart';
import '../repositories/user_repository.dart';

class AvatarProfileComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: UserRepository().getUser(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the result, you can show a loading indicator.
          // return const CircularProgressIndicator();
          return Container(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 36,
              bottom: 36,
            ),
            child: const Text('Loading'),
          );
        } else if (snapshot.hasError) {
          // Handle the error case here.
          return Text('Error: ${snapshot.error}');
        } else {
          return Container(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 36,
              bottom: 36,
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30, // Image radius
                  backgroundImage: AssetImage("images/profile_placeholder.jpg"),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data!.name,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                    Text(
                      snapshot.data!.kontak,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      snapshot.data!.email,
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
      },
    );
  }
}
