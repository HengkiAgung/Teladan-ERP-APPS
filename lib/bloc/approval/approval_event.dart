part of 'approval_bloc.dart';

class ApprovalEvent extends Equatable {
  const ApprovalEvent();

  @override
  List<Object> get props => [];
}

class GetRequest extends ApprovalEvent {
  final String key;
  final String type;
  final dynamic model;

  const GetRequest({required this.key, required this.type, required this.model});
}

class GetRequestDetail extends ApprovalEvent {
  final String id;
  final String type;
  final dynamic model;

  const GetRequestDetail({required this.id, required this.type, required this.model});
}
