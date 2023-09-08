import 'package:teladan/components/request_item_component.dart';
import 'package:teladan/repositories/approval_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/Attendance/UserShiftRequest.dart';
import 'detail_shift_approval_page.dart';

class ShiftApprovalPage extends StatefulWidget {
  const ShiftApprovalPage({super.key});

  @override
  State<ShiftApprovalPage> createState() => _ShiftApprovalPageState();
}

class _ShiftApprovalPageState extends State<ShiftApprovalPage> {
  List<UserShiftRequest> userShiftRequest = [];

  late ScrollController _scrollController;
  int page = 1;

  void fetchShiftRequest() async {
    var data =
        await ApprovalRepository().getShiftApproval(page: page.toString());
    setState(() {
      userShiftRequest.addAll(data);
    });
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        page++;
      });
      fetchShiftRequest();
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchShiftRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                "Request Shift",
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
      body: ListView.builder(
        controller: _scrollController,
        itemCount: userShiftRequest.length,
        itemBuilder: (BuildContext context, int index) {
          var request = userShiftRequest[index];
          return RequestItemComponent(
            fun: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailShiftApprovalPage(
                    id: request.id.toString(),
                  ),
                ),
              );
            },
            title: request.user!.name,
            status: request.status,
            children: [
              Text(
                "Tanggal ${request.date}",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
