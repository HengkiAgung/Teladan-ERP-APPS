import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/Attendance/UserAttendanceRequest.dart';
import '../../models/Attendance/UserLeaveRequest.dart';
import '../../models/Attendance/UserShiftRequest.dart';
import '../../repositories/request_repository.dart';
import '../../utils/auth.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  RequestBloc() : super(RequestInitial()) {
    on<GetRequestAttendanceList>((event, emit) async {
      emit(RequestLoading());
      try {
        UserAttendanceRequest model = UserAttendanceRequest();
        String? token = await Auth().getToken();

        final List<dynamic> employee = await RequestRepository().getAllUserRequest(type: "attendance", key: "userAttendanceRequest", model: model);

        emit(RequestAttendanceListLoadSuccess(employee as List<UserAttendanceRequest>));

      } catch (error) {
        emit(RequestLoadFailure(error: error.toString()));
      }
    });

    on<GetRequestShiftList>((event, emit) async {
      emit(RequestLoading());
      try {
        UserShiftRequest model = UserShiftRequest();
        String? token = await Auth().getToken();

        final List<dynamic> employee = await RequestRepository().getAllUserRequest(type: "attendance", key: "userShiftRequest", model: model);

        emit(RequestShiftListLoadSuccess(employee as List<UserShiftRequest>));

      } catch (error) {
        emit(RequestLoadFailure(error: error.toString()));
      }
    });

    on<GetRequestLeaveList>((event, emit) async {
      emit(RequestLoading());
      try {
        UserLeaveRequest model = UserLeaveRequest();
        String? token = await Auth().getToken();

        final List<dynamic> employee = await RequestRepository().getAllUserRequest(type: "attendance", key: "userLeaveRequest", model: model);

        emit(RequestLeaveListLoadSuccess(employee as List<UserLeaveRequest>));

      } catch (error) {
        emit(RequestLoadFailure(error: error.toString()));
      }
    });

    on<GetRequestDetail>((event, emit) async {
      emit(RequestLoading());
      try {
        String? token = await Auth().getToken();

        final dynamic employee = await RequestRepository().getDetailRequest(id: event.id, type: event.type, model: event.model);

        emit(RequestDetailLoadSuccess(employee));

      } catch (error) {
        emit(RequestLoadFailure(error: error.toString()));
      }
    });
    
  }
}
