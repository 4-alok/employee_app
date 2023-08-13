import 'dart:math';

import 'package:employee/bloc/employee_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/global/names.dart';
import '../../data/models/employee_model.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  String get getRandomName => names[Random().nextInt(names.length)];

  EmployeeRole get getRandomRole =>
      EmployeeRole.values[Random().nextInt(EmployeeRole.values.length)];

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Employee App')),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case LoadingEmployees:
              return const Center(child: CircularProgressIndicator());
            case EmployeesLoaded:
              return employeeList((state as EmployeesLoaded).employees);
            default:
              return const Text('Something went wrong!');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<EmployeeBloc>().add(CreateEmployee(
              Employee(
                name: getRandomName,
                role: getRandomRole,
                id: DateTime.now().millisecond.toString(),
                dateTime1: DateTime.now(),
                dateTime2: DateTime.now(),
              ),
            )),
        child: const Icon(Icons.add),
      ));

  Widget employeeList(List<Employee> employees) => ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          return ListTile(
            title: Text(employee.name),
            subtitle: Text(employee.roleString),
            leading: CircleAvatar(
              child: Text(employee.name[0]),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () =>
                  context.read<EmployeeBloc>().add(DeleteEmployee(employee)),
            ),
            onTap: () => context
                .read<EmployeeBloc>()
                .add(UpdateEmployee(employee.copyWith(
                  name: getRandomName,
                  role: getRandomRole,
                ))),
          );
        },
      );
}
