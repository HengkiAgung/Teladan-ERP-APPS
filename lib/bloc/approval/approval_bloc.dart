import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/approval_repository.dart';
import '../../utils/auth.dart';

part 'approval_event.dart';
part 'approval_state.dart';

class ApprovalBloc extends Bloc<ApprovalEvent, ApprovalState> {
  ApprovalBloc() : super(ApprovalInitial()) {
    on<GetRequest>((event, emit) async {
      emit(ApprovalLoading());
      try {
        String? token = await Auth().getToken();

        final List<dynamic> attendance = await ApprovalRepository().getRequest(key: event.key, type: event.type, model: event.model, token: token!);

        emit(ApprovalListLoadSuccess(attendance));

      } catch (error) {
        emit(ApprovalLoadFailure(error: error.toString()));
      }
    });

    on<GetRequestDetail>((event, emit) async {
      emit(ApprovalLoading());
      try {
        String? token = await Auth().getToken();

        final dynamic attendance = await ApprovalRepository().getDetailAttendanceRequest(id: event.id, type: event.type, model: event.model, token: token!);

        emit(ApprovalDetailLoadSuccess(attendance));

      } catch (error) {
        emit(ApprovalLoadFailure(error: error.toString()));
      }
    });
  }
}
