part of 'employee_bloc.dart';

@immutable
abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class LoadEmployees extends EmployeeEvent {}

class CreateEmployee extends EmployeeEvent {
  final Employee employee;
  final int? index;

  const CreateEmployee(this.employee, [this.index]);
}

class UpdateEmployee extends EmployeeEvent {
  final Employee employee;

  const UpdateEmployee(this.employee);
}

class DeleteEmployee extends EmployeeEvent {
  final Employee employee;

  const DeleteEmployee(this.employee);
}
