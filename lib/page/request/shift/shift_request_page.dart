import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teladan/page/request/shift/form_shift_request_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../bloc/request_detail/request_detail_bloc.dart';
import '../../../bloc/request_shift_list/request_shift_list_bloc.dart';
import '../../../models/Attendance/UserShiftRequest.dart';
import '../../../models/Employee/WorkingShift.dart';
import '../../../repositories/request_repository.dart';
import '../../../utils/auth.dart';
import '../../../utils/middleware.dart';
import 'detail_shift_request_page.dart';

class ShiftRequestPage extends StatefulWidget {
  const ShiftRequestPage({super.key});

  @override
  State<ShiftRequestPage> createState() => _ShiftRequestPageState();
}

class _ShiftRequestPageState extends State<ShiftRequestPage> {
  List<UserShiftRequest> _userShiftRequest = [];

  late ScrollController _scrollController;
  int page = 1;

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      page = page + 1;
      context.read<RequestShiftListBloc>().add(
            ScrollFetch(
              page: page,
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
    final shiftRequest = BlocProvider.of<RequestShiftListBloc>(context);
    if (shiftRequest.state is! RequestShiftListLoadSuccess) {
      // context.read<UserBloc>().add(CheckAuth());
      // final user = BlocProvider.of<UserBloc>(context);

      // if (user.state is UserUnauthenticated) Auth().logOut(context);

      Middleware().authenticated(context);

      context.read<RequestShiftListBloc>().add(GetRequestList());
    }

    return Column(
      children: [
        Container(
          height: (MediaQuery.of(context).size.height) - 280,
          child: BlocBuilder<RequestShiftListBloc, RequestShiftListState>(
            builder: (context, state) {
              if (state is RequestShiftListLoading) {
                return const Padding(
                  padding: EdgeInsets.only(top: 18.0, left: 18),
                  child: Text("loading..."),
                );
              } else if (state is RequestShiftListLoadFailure) {
                return const Text("Failed to load shift request");
              } else if (state is RequestShiftListLoadSuccess) {
                _userShiftRequest = state.request.cast<UserShiftRequest>();
              }

              return RefreshIndicator(
                onRefresh: () async {
                  // context.read<UserBloc>().add(CheckAuth());
                  // final user = BlocProvider.of<UserBloc>(context);

                  // if (user.state is UserUnauthenticated) Auth().logOut(context);
                  Middleware().authenticated(context);

                  context.read<RequestShiftListBloc>().add(GetRequestList());
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _userShiftRequest.length,
                        itemBuilder: (BuildContext context, int index) {
                          var shift = _userShiftRequest[index];
                          Color colorStatus;

                          if (shift.status == "Waiting") {
                            colorStatus = Colors.amber;
                          } else if (shift.status == "Approved") {
                            colorStatus = Colors.green;
                          } else {
                            colorStatus = Colors.red.shade900;
                          }

                          return Container(
                            padding: const EdgeInsets.only(
                              right: 10,
                              left: 10,
                              top: 20,
                              bottom: 20,
                            ),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: Color.fromARGB(160, 158, 158, 158),
                                ),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                // context.read<UserBloc>().add(CheckAuth());
                                // final user = BlocProvider.of<UserBloc>(context);

                                // if (user.state is UserUnauthenticated) Auth().logOut(context);
                                Middleware().authenticated(context);


                                context.read<RequestDetailBloc>().add(
                                    GetRequestDetail(
                                        id: shift.id.toString(),
                                        type: "shift",
                                        model: UserShiftRequest()));

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailShiftRequestPage(id: shift.id),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          shift.date,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 51, 51, 51),
                                          ),
                                        ),
                                        shift.approvalLine!.name != ""
                                            ? Text(
                                                "Approved by: ${shift.approvalLine!.name}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            : const SizedBox(),
                                        Text(
                                          "Status",
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          shift.status,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: colorStatus,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.more_vert),
                                    const SizedBox(
                                      width: 12,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    (state is RequestShiftListFetchNew)
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
        ),
        GestureDetector(
          onTap: () async {
            String token = await Auth().getToken();

            WorkingShift currentShift =
                await RequestRepository().getCurrentShift(token: token);

            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FormShiftRequestPage(currentShift: currentShift),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              'Ajukan Perubahan Shift',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
