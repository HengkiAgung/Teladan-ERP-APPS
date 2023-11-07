import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teladan/components/request_item_component.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../bloc/approval_detail/approval_detail_bloc.dart';
import '../../../../bloc/approval_list/approval_list_bloc.dart';
import '../../../../models/Attendance/UserLeaveRequest.dart';
import '../../../../utils/middleware.dart';
import 'detail_time_off_approval_page.dart';

class TimeOffApprovalPage extends StatefulWidget {
  const TimeOffApprovalPage({super.key});

  @override
  State<TimeOffApprovalPage> createState() => _TimeOffApprovalPageState();
}

class _TimeOffApprovalPageState extends State<TimeOffApprovalPage> {
  List<dynamic> _request = [];

  late ScrollController _scrollController;
  int page = 1;

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      page = page + 1;
      context.read<ApprovalListBloc>().add(
            ScrollFetch(
              page: page,
              key: 'userTimeOffRequest',
              type: 'time-off',
              model: UserLeaveRequest(),
            ),
          );
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

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
      body: BlocBuilder<ApprovalListBloc, ApprovalListState>(
        builder: (context, state) {
          if (state is ApprovalListLoading) {
            return const Padding(
              padding: EdgeInsets.only(top: 18.0, left: 18),
              child: Text("loading..."),
            );
          } else if (state is ApprovalListLoadFailure) {
            return Text("Failed to load attendance log");
          } else if (state is ApprovalListLoadSuccess) {
            _request = state.request;
          }

          return RefreshIndicator(
            onRefresh: () async {
              Middleware().authenticated(context);

              context.read<ApprovalListBloc>().add(GetRequestList(
                    key: 'userTimeOffRequest',
                    type: 'time-off',
                    model: UserLeaveRequest(),
                  ));
            },
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _request.length > 9 ? _scrollController : null,
                    itemCount: _request.length,
                    itemBuilder: (BuildContext context, int index) {
                      var request = _request[index];
                      return RequestItemComponent(
                        fun: () {
                          Middleware().authenticated(context);

                          context.read<ApprovalDetailBloc>().add(
                              GetRequestDetail(
                                  id: request.id.toString(),
                                  type: "time-off",
                                  model: UserLeaveRequest()));

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
                ),
                (state is ApprovalListFetchNew)
                    ? const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: SizedBox(
                          height: 40,
                          child: Text("Loading..."),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }
}
