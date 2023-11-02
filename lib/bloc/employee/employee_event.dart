part of 'employee_bloc.dart';

class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class GetEmployee extends EmployeeEvent {}

class LogOut extends EmployeeEvent {}

class ScrollFetch extends EmployeeEvent {
  final int page;

  const ScrollFetch({required this.page});
}