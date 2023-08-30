import 'package:comtelindo_erp/models/Attendance/LeaveRequestCategory.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../repositories/request_repository.dart';

class FormTimeOffRequestPage extends StatefulWidget {
  const FormTimeOffRequestPage({super.key});

  @override
  State<FormTimeOffRequestPage> createState() => _FormTimeOffRequestPageState();
}

class _FormTimeOffRequestPageState extends State<FormTimeOffRequestPage> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  PlatformFile? _selectedFile;
  String? _categoryId;

  final TextEditingController _reasonController = TextEditingController();

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
                "Request Time Off",
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
            onTap: () async {
              bool makeRequest = await RequestRepository().makeLeaveRequest(
                context,
                _startDate,
                _endDate,
                _categoryId,
                _reasonController.text,
                _selectedFile,
              );

              if (makeRequest) {
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }
            },
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
      body: FutureBuilder<List<LeaveRequestCategory>>(
        future: RequestRepository().getAllLeaveRequestCategory(),
        builder: (BuildContext context, AsyncSnapshot<List<LeaveRequestCategory>> snapshot) {
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
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "Form Pengajuan Waktu Istirahat",
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
                      const Icon(
                        Icons.cases_outlined,
                        color: Color.fromARGB(255, 109, 109, 109),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: DropdownButton<String>(
                          value: _categoryId,
                          hint: Text("Kategory time off"),
                          isExpanded: true,
                          underline: Container(
                            height: 2,
                            color: Colors.amber,
                          ),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              _categoryId = value!;
                            });
                          },
                          items: snapshot.data!.map<DropdownMenuItem<String>>(
                              (LeaveRequestCategory value) {
                            return DropdownMenuItem<String>(
                              value: value.id.toString(),
                              child: Text(value.name),
                            );
                          }).toList(),
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
                              initialDate: _startDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2025),
                            );

                            if (newDate == null) return;
                            setState(() => _startDate = newDate);
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
                                  "Tanggal Mulai",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "${_startDate.year}/${_startDate.month}/${_startDate.day}",
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
                        width: 51,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: _endDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2025),
                            );

                            if (newDate == null) return;
                            setState(() => _endDate = newDate);
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
                                  "Tanggal Selesai",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "${_endDate.year}/${_endDate.month}/${_endDate.day}",
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
                            controller: _reasonController,
                            obscureText: false,
                            decoration: const InputDecoration(
                              labelText: 'Alasan',
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
                            setState(() => _selectedFile = file.files.first);
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
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: const Icon(Icons.add),
                                ),
                                Text(
                                  _selectedFile?.path ?? "Max file 10MB",
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
            );
          }
        },
      ),
    );
  }
}
