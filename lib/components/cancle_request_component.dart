import '../../repositories/approval_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../repositories/request_repository.dart';

class CancleRequestComponent extends StatelessWidget {
  int id;
  String type;
  final dynamic source;

  CancleRequestComponent({super.key, required this.id, required this.type, required this.source});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 212, 212, 212),
            blurRadius: 4,
            offset: Offset(-2, 2), // Shadow position
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          bool updated = await RequestRepository().cancelRequest(id: id, type: type);
          if (updated) {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                  source,
              ),
            );
          }
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.amber
          ),
          child: Text(
            "Cancle",
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
