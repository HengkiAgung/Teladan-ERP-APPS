import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'leave_quota_event.dart';
part 'leave_quota_state.dart';

class LeaveQuotaBloc extends Bloc<LeaveQuotaEvent, LeaveQuotaState> {
  LeaveQuotaBloc() : super(LeaveQuotaInitial()) {
    on<LeaveQuotaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
