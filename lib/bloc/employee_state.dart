part of 'employee_bloc.dart';

@immutable
abstract class EmployeeState {
  const EmployeeState();
}

class LoadingEmployees extends EmployeeState {}

class EmployeesLoaded extends EmployeeState {
  final List<Employee> employees;

  const EmployeesLoaded(this.employees);
}
