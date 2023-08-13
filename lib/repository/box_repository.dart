import 'package:employee/data/models/employee_model.dart';
import 'package:hive_flutter/adapters.dart';

class BoxRepository {
  late final Box box;

  Future<void> init() async {
    box = await Hive.openBox<Employee>('employee');
  }

  Future<void> addEmployee(Employee employee) async => await box.add(employee);

  Future<void> updateEmployee(Employee employee) async {
    final employees = box.values.toList().cast<Employee>();
    final index = employees.indexWhere((element) => element.id == employee.id);
    if (index != -1) await box.putAt(index, employee);
  }

  Future<void> deleteEmployee(Employee employee) async {
    final employees = box.values.toList().cast<Employee>();
    final index = employees.indexWhere((element) => element.id == employee.id);
    if (index != -1) await box.deleteAt(index);
  }

  Future<List<Employee>> getAllEmployees() async {
    return box.values.toList().cast<Employee>();
  }

  Future<void> close() async => await box.close();
}
