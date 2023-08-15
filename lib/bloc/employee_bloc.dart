import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

import '../data/models/employee_model.dart';
import '../repository/box_repository.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final BoxRepository boxRepository;

  EmployeeBloc(this.boxRepository) : super(LoadingEmployees()) {
    on<LoadEmployees>(_loadEmployees);
    on<CreateEmployee>(_createEmployee);
    on<UpdateEmployee>(_updateEmployee);
    on<DeleteEmployee>(_deleteEmployee);
  }

  Future<void> _createEmployee(
      CreateEmployee event, Emitter<EmployeeState> emit) async {
    await boxRepository.addEmployee(event.employee, event.index);
    emit(EmployeesLoaded(await boxRepository.getAllEmployees()));
  }

  Future<void> _updateEmployee(
      UpdateEmployee event, Emitter<EmployeeState> emit) async {
    await boxRepository.updateEmployee(event.employee);
    emit(EmployeesLoaded(await boxRepository.getAllEmployees()));
  }

  Future<void> _deleteEmployee(
      DeleteEmployee event, Emitter<EmployeeState> emit) async {
    await boxRepository.deleteEmployee(event.employee);
    emit(EmployeesLoaded(await boxRepository.getAllEmployees()));
  }

  Future<void> _loadEmployees(
      LoadEmployees event, Emitter<EmployeeState> emit) async {
    final employees = await boxRepository.getAllEmployees();
    emit(
      EmployeesLoaded(employees),
    );
  }
}
