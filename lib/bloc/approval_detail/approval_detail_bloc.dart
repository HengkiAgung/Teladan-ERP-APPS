import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'approval_detail_event.dart';
part 'approval_detail_state.dart';

class ApprovalDetailBloc extends Bloc<ApprovalDetailEvent, ApprovalDetailState> {
  ApprovalDetailBloc() : super(ApprovalDetailInitial()) {
    on<ApprovalDetailEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
