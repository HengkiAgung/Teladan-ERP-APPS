import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/Employee/User.dart';
import '../../repositories/employee_repository.dart';
import '../../utils/auth.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(EmployeeInitial()) {
    on<GetEmployee>((event, emit) async {
      emit(EmployeeLoading());
      try {
        String? token = await Auth().getToken();

        final List<User> employee = await EmployeeRepository().getAllUser(token: token,);

        emit(EmployeeLoadSuccess(employee));

      } catch (error) {
        emit(EmployeeLoadFailure(error: error.toString()));
      }
    });

    on<LogOut>((event, emit) async {
      emit(EmployeeInitial());
    });
  }
}
