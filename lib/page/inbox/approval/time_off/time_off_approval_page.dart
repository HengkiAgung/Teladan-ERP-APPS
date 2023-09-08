import 'package:teladan/components/request_item_component.dart';
import 'package:teladan/repositories/approval_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/Attendance/UserLeaveRequest.dart';
import 'detail_time_off_approval_page.dart';

class TimeOffApprovalPage extends StatefulWidget {
  const TimeOffApprovalPage({super.key});

  @override
  State<TimeOffApprovalPage> createState() => _TimeOffApprovalPageState();
}

class _TimeOffApprovalPageState extends State<TimeOffApprovalPage> {
  List<UserLeaveRequest> userTimeOffRequest = [];

  late ScrollController _scrollController;
  int page = 1;

  void fetchTimeOffRequest() async {
    var data =
        await ApprovalRepository().getTimeOffApproval(page: page.toString());
    setState(() {
      userTimeOffRequest.addAll(data);
    });
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        page++;
      });
      fetchTimeOffRequest();
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchTimeOffRequest();
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
      body: ListView.builder(
        controller: _scrollController,
        itemCount: userTimeOffRequest.length,
        itemBuilder: (BuildContext context, int index) {
          var request = userTimeOffRequest[index];
          return RequestItemComponent(
            fun: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailTimeOffApprovalPage(
                    id: request.id.toString(),
                  ),
                ),
              );
            },
            title: request.user!.name,
            status: request.status,
            children: [
              Text(
                "Tanggal ${request.start_date} - ${request.end_date}",
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
