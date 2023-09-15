part of 'approval_bloc.dart';

class ApprovalState extends Equatable {
  const ApprovalState();
  
  @override
  List<Object> get props => [];
}

class ApprovalInitial extends ApprovalState {}

class ApprovalLoading extends ApprovalState {}

class ApprovalListLoadSuccess extends ApprovalState {
  final List<dynamic> request;

  const ApprovalListLoadSuccess(this.request);
}

class ApprovalDetailLoadSuccess extends ApprovalState {
  final dynamic request;

  const ApprovalDetailLoadSuccess(this.request);
}

class ApprovalLoadFailure extends ApprovalState {
  final String error;

  const ApprovalLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load employee {error: $error}';
  }
}
