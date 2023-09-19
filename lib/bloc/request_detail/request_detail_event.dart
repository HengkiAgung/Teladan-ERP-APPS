part of 'request_detail_bloc.dart';

class RequestDetailEvent extends Equatable {
  const RequestDetailEvent();

  @override
  List<Object> get props => [];
}

class GetRequestDetail extends RequestDetailEvent{
  late String id;
  late String type;
  late dynamic model;
  GetRequestDetail({required this.id, required this.type, required this.model});
}
