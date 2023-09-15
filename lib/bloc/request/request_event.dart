part of 'request_bloc.dart';

class RequestEvent extends Equatable {
  const RequestEvent();

  @override
  List<Object> get props => [];
}

class GetRequestAttendanceList extends RequestEvent {}

class GetRequestShiftList extends RequestEvent {}

class GetRequestLeaveList extends RequestEvent {}

class GetRequestDetail extends RequestEvent {
  final String id;
  final String type;
  final dynamic model;

  const GetRequestDetail({required this.id, required this.type, required this.model});
}
