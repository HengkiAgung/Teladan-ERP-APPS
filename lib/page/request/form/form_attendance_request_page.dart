import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormAttendanceRequestPage extends StatefulWidget {
  const FormAttendanceRequestPage({super.key});

  @override
  State<FormAttendanceRequestPage> createState() =>
      _FormAttendanceRequestPageState();
}

class _FormAttendanceRequestPageState extends State<FormAttendanceRequestPage> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTimeIn = null;
  TimeOfDay? _selectedTimeOut = null;
  String ? _selectedFilePath = null;
  final TextEditingController _descriptionController = TextEditingController();

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
                "Request Attendance",
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
      bottomNavigationBar: Container(
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
        child: Expanded(
          child: InkWell(
            onTap: () async {},
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Kirim',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "Form Pengajuan Absensi",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 51, 51, 51),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                const Icon(Icons.calendar_month,
                    color: Color.fromARGB(255, 109, 109, 109)),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2025),
                      );

                      if (newDate == null) return;
                      setState(() => _selectedDate = newDate);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 0.5,
                            color: Color.fromARGB(160, 158, 158, 158),
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pilih Tanggal",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "" + _selectedDate.year.toString() + "/" + _selectedDate.month.toString() + "/" + _selectedDate.day.toString(),
                            // '',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                const Icon(Icons.access_time_outlined,
                    color: Color.fromARGB(255, 109, 109, 109)),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap:() async {
                      TimeOfDay? newTime = await showTimePicker(context: context, initialTime: TimeOfDay.now(),);
                      if (newTime == null) return;
                      setState(() => _selectedTimeIn = newTime);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 0.5,
                            color: Color.fromARGB(160, 158, 158, 158),
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Clock In",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            _selectedTimeIn == null ? "-" : "${_selectedTimeIn!.hour}:${_selectedTimeIn!.minute}",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                const Icon(Icons.access_time_filled,
                    color: Color.fromARGB(255, 109, 109, 109)),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap:() async {
                      TimeOfDay? newTime = await showTimePicker(context: context, initialTime: TimeOfDay.now(),);
                      if (newTime == null) return;
                      setState(() => _selectedTimeOut = newTime);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 0.5,
                            color: Color.fromARGB(160, 158, 158, 158),
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Clock Out",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            _selectedTimeOut == null ? "-" : "${_selectedTimeOut!.hour}:${_selectedTimeOut!.minute}",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                const Icon(Icons.text_snippet_outlined,
                    color: Color.fromARGB(255, 109, 109, 109)),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 0.5,
                          color: Color.fromARGB(160, 158, 158, 158),
                        ),
                      ),
                    ),
                    child: TextField(
                      controller: _descriptionController,
                      obscureText: false,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi',
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                const Icon(Icons.file_upload_outlined,
                    color: Color.fromARGB(255, 109, 109, 109)),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final file = await FilePicker.platform.pickFiles();
                      if (file == null) return;
                      setState(() => _selectedFilePath = file.files.first.path);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 0.5,
                            color: Color.fromARGB(160, 158, 158, 158),
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Unggah File",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: const Icon(Icons.add),
                          ),
                          Text(
                            _selectedFilePath == null ? "Max file 10MB" : _selectedFilePath!,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
