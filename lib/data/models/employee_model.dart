// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/adapters.dart';

part 'employee_model.g.dart';

extension EmployeeRoleExtension on EmployeeRole {
  String get roleString {
    switch (this) {
      case EmployeeRole.productDesigner:
        return 'Product Designer';
      case EmployeeRole.flutterDeveloper:
        return 'Flutter Developer';
      case EmployeeRole.qaTester:
        return 'QA Tester';
      case EmployeeRole.productOwner:
        return 'Product Owner';
      default:
        return '';
    }
  }
}

@HiveType(typeId: 1)
enum EmployeeRole {
  @HiveField(0)
  productDesigner,
  @HiveField(1)
  flutterDeveloper,
  @HiveField(2)
  qaTester,
  @HiveField(3)
  productOwner,
}

@HiveType(typeId: 0)
class Employee {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final EmployeeRole role;
  @HiveField(3)
  final DateTime dateTime1;
  @HiveField(4)
  final DateTime? dateTime2;

  const Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.dateTime1,
    this.dateTime2,
  });

  String get roleString {
    switch (role) {
      case EmployeeRole.productDesigner:
        return 'Product Designer';
      case EmployeeRole.flutterDeveloper:
        return 'Flutter Developer';
      case EmployeeRole.qaTester:
        return 'QA Tester';
      case EmployeeRole.productOwner:
        return 'Product Owner';
    }
  }

  Employee copyWith({
    String? id,
    String? name,
    EmployeeRole? role,
    DateTime? dateTime1,
    DateTime? dateTime2,
  }) =>
      Employee(
        id: id ?? this.id,
        name: name ?? this.name,
        role: role ?? this.role,
        dateTime1: dateTime1 ?? this.dateTime1,
        dateTime2: dateTime2 ?? this.dateTime2,
      );
}
