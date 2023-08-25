import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/error_notification_component.dart';
import '../../models/Employee/User.dart';
import '../../repositories/user_repository.dart';

class PersonalPage extends StatelessWidget {
  PersonalPage({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _placeOfBirthController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _maritalStatusController =
      TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _religionController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: const Color.fromARGB(255, 226, 226, 226),
            height: 1,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Center(
              child: Text(
                "Info Personal",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const Spacer()
        ],
      ),
      body: FutureBuilder<User>(
        future: UserRepository().getUserPersonalData(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the result, you can show a loading indicator.
            // return const CircularProgressIndicator();
            return const Text('Loading');
          } else if (snapshot.hasError) {
            // Handle the error case here.
            return Text('Error: ${snapshot.error}');
          } else {
            _nameController.text = snapshot.data!.name;
            _emailController.text = snapshot.data!.email;
            _phoneController.text = snapshot.data!.kontak;
            _placeOfBirthController.text =
                snapshot.data!.userPersonalData!.place_of_birth;
            _birthdateController.text =
                snapshot.data!.userPersonalData!.birthdate;
            _maritalStatusController.text =
                snapshot.data!.userPersonalData!.marital_status;
            _genderController.text = snapshot.data!.userPersonalData!.gender;
            _religionController.text = snapshot.data!.userPersonalData!.religion;
            _bloodTypeController.text =
                snapshot.data!.userPersonalData!.blood_type;

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "Informasi Pribadi",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                  ),

                  // name
                  TextField(
                    readOnly: true,
                    controller: _nameController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // email
                  TextField(
                    readOnly: true,
                    controller: _emailController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // phone
                  TextField(
                    readOnly: true,
                    controller: _phoneController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // placeOfBirth
                  TextField(
                    readOnly: true,
                    controller: _placeOfBirthController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: 'Place Of Birth',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // birthdate
                  TextField(
                    readOnly: true,
                    controller: _birthdateController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: 'Birthdate',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // maritalStatus
                  TextField(
                    readOnly: true,
                    controller: _maritalStatusController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: 'Marital Status',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // gender
                  TextField(
                    readOnly: true,
                    controller: _genderController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // religion
                  TextField(
                    readOnly: true,
                    controller: _religionController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: 'Religion',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // bloodType
                  TextField(
                    readOnly: true,
                    controller: _bloodTypeController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: 'Blood Type',
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
