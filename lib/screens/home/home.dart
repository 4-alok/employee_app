import 'package:employee/bloc/employee_bloc.dart';
import 'package:employee/data/global/extension/data_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/models/employee_model.dart';
import '../add_update_employee/add_update_employee.dart';
import 'widget/grouped_list.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Employee App'),
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case LoadingEmployees:
              return const Center(child: CircularProgressIndicator());
            case EmployeesLoaded:
              return employeeList(
                  context, (state as EmployeesLoaded).employees);
            default:
              return const Text('Something went wrong!');
          }
        },
      ),
      floatingActionButton: fab(context));

  FloatingActionButton fab(BuildContext context) => FloatingActionButton(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddUpdateEmployee(),
            )),
        child: const Icon(Icons.add),
      );

  Widget employeeList(BuildContext context, List<Employee> employees) =>
      GroupedListView(
        shrinkWrap: true,
        elements: employees,
        groupBy: (element) => element.dateTime2 == null
            ? 'Current employee'
            : 'Previous employee',
        groupSeparatorBuilder: (String groupByValue) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Text(
            groupByValue,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        separator: Container(
          height: 1,
          color: Colors.grey[300],
        ),
        itemBuilder: (context, employee) => Dismissible(
          direction: DismissDirection.endToStart,
          key: Key(employee.id),
          onDismissed: (dir) {
            context.read<EmployeeBloc>().add(DeleteEmployee(employee));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Employee data has been deleted'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () => context.read<EmployeeBloc>().add(
                      CreateEmployee(employee, employees.indexOf(employee))),
                ),
              ),
            );
          },
          background: const SizedBox(),
          secondaryBackground: Container(
            color: Colors.red,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SvgPicture.asset('assets/svg/icons/delete.svg'),
              ),
            ),
          ),
          child: employeeTile(employee, context),
        ),
        bottomWidget: employees.isEmpty
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child:
                    Center(child: SvgPicture.asset('assets/svg/no_data.svg')))
            : const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Swipe left to delete",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ),
      );

  Widget employeeTile(Employee employee, BuildContext context) => InkWell(
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  employee.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  employee.roleString,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                employee.dateTime2 == null
                    ? Text(
                        "From ${employee.dateTime1.to_d_MMM_yyyy}",
                        style: const TextStyle(color: Colors.grey),
                      )
                    : Text(
                        "From ${employee.dateTime1.to_d_MMMc_yyyy} - ${employee.dateTime2!.to_d_MMMc_yyyy}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddUpdateEmployee(employee: employee),
          ),
        ),
      );

  String insert(int index, String char, String text) {
    if (index >= 0 && index <= text.length) {
      return text.substring(0, index) + char + text.substring(index);
    }
    return text;
  }
}
