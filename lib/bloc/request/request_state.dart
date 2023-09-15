part of 'request_bloc.dart';

class RequestState extends Equatable {
  const RequestState();
  
  @override
  List<Object> get props => [];
}

class RequestInitial extends RequestState {}

class RequestLoading extends RequestState {}

class RequestAttendanceListLoadSuccess extends RequestState {
  final List<UserAttendanceRequest> request;

  const RequestAttendanceListLoadSuccess(this.request);
}

class RequestShiftListLoadSuccess extends RequestState {
  final List<UserShiftRequest> request;

  const RequestShiftListLoadSuccess(this.request);
}

class RequestLeaveListLoadSuccess extends RequestState {
  final List<UserLeaveRequest> request;

  const RequestLeaveListLoadSuccess(this.request);
}

class RequestDetailLoadSuccess extends RequestState {
  final dynamic request;

  const RequestDetailLoadSuccess(this.request);
}

class RequestLoadFailure extends RequestState {
  final String error;

  const RequestLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load request {error: $error}';
  }
}