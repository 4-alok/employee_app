import 'package:employee/data/global/extension/data_format.dart';
import 'package:employee/data/models/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../bloc/employee_bloc.dart';
import 'widgets/calendar_widget.dart';

class AddUpdateEmployee extends StatefulWidget {
  const AddUpdateEmployee({this.employee, super.key});
  final Employee? employee;

  @override
  State<AddUpdateEmployee> createState() => _AddUpdateEmployeeState();
}

class _AddUpdateEmployeeState extends State<AddUpdateEmployee> {
  final controller = TextEditingController();
  final selectedRole = ValueNotifier<EmployeeRole?>(null);
  final date1 = ValueNotifier<DateTime?>(null);
  final date2 = ValueNotifier<DateTime?>(null);

  @override
  void initState() {
    if (widget.employee != null) {
      controller.text = widget.employee!.name;
      selectedRole.value = widget.employee!.role;
      date1.value = widget.employee!.dateTime1;
      date2.value = widget.employee!.dateTime2;
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    selectedRole.dispose();
    date1.dispose();
    date2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar(context),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          children: [
            employeeName(),
            const SizedBox(height: 16),
            selectRole(context),
            const SizedBox(height: 16),
            selectDate(),
            const SizedBox(height: 16),
          ],
        ),
        bottomNavigationBar: bottomNavigationBar(context),
      );

  Widget selectDate() => Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              height: 49,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1.2,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () async {
                  final res = await showDialog<DateTime?>(
                      context: context,
                      builder: (context) => CalendarDialog(
                            initialDate: date1.value,
                            option: CalendarOption.option1,
                          ));

                  if (res != null) {
                    if (date2.value != null) {
                      if (res.isAfter(date2.value!)) {
                        date2.value = null;
                      }
                    }
                    date1.value = res;
                  }
                },
                child: Row(
                  children: [
                    SvgPicture.asset('assets/svg/icons/date.svg',
                        height: 24, width: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: date1,
                        builder: (context, value, child) => value == null
                            ? Text(
                                'No Date',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              )
                            : Text(
                                value.to_d_MMM_yyyy,
                                style: const TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SvgPicture.asset('assets/svg/icons/arrow.svg',
                height: 12, width: 12),
          ),
          Expanded(
            child: Container(
              height: 49,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1.2,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ValueListenableBuilder(
                  valueListenable: date1,
                  builder: (_, __, ___) => GestureDetector(
                        onTap: date1.value == null
                            ? null
                            : () async =>
                                date2.value = await showDialog<DateTime?>(
                                        context: context,
                                        builder: (context) => CalendarDialog(
                                              initialDate: date2.value,
                                              option: CalendarOption.option2,
                                              option2InitialDate: date1.value,
                                            )) ??
                                    date2.value,
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/svg/icons/date.svg',
                                height: 24, width: 24),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ValueListenableBuilder(
                                valueListenable: date2,
                                builder: (context, value, child) => value ==
                                        null
                                    ? Text(
                                        'No Date',
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      )
                                    : Text(
                                        value.to_d_MMM_yyyy,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      )),
            ),
          ),
        ],
      );

  Widget selectRole(BuildContext context) => GestureDetector(
        onTap: () => showModalBottomSheet(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          context: context,
          builder: (context) => SizedBox(
            height: EmployeeRole.values.length * (50 + 1).toDouble(),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: EmployeeRole.values.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: Colors.grey[300],
                ),
                itemBuilder: (BuildContext context, int index) {
                  final role = EmployeeRole.values[index];
                  return InkWell(
                    borderRadius: index == 0
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))
                        : null,
                    onTap: () {
                      selectedRole.value = role;
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(role.roleString),
                        )),
                  );
                },
              ),
            ),
          ),
        ),
        child: Container(
          height: 49,
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1.2,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              SvgPicture.asset('assets/svg/icons/role.svg',
                  height: 24, width: 24),
              const SizedBox(width: 10),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: selectedRole,
                  builder: (context, value, child) => value == null
                      ? Text(
                          'Select Role',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        )
                      : Text(
                          value.roleString,
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
              Icon(
                Icons.arrow_drop_down_rounded,
                size: 30,
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      );

  Widget employeeName() => TextFormField(
        controller: controller,
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        textAlignVertical: TextAlignVertical.center,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        decoration: InputDecoration(
          labelText: 'Employee name',
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset('assets/svg/icons/person.svg'),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1.2, color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1.2, color: Colors.grey[500]!),
          ),
        ),
        style: const TextStyle(height: 1),
      );

  Widget bottomNavigationBar(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: AppBar().preferredSize.height,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1, color: Colors.grey[300]!),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor.withOpacity(.1)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => save(),
              style: ElevatedButton.styleFrom(elevation: 0),
              child: const Text("Save"),
            ),
          ],
        ),
      );

  AppBar appBar(BuildContext context) => AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: widget.employee != null
            ? const Text('Edit employee details')
            : const Text('Add Employee'),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        actions: [
          widget.employee == null
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context
                        .read<EmployeeBloc>()
                        .add(DeleteEmployee(widget.employee!));
                  },
                  icon: SvgPicture.asset('assets/svg/icons/delete.svg'),
                ),
        ],
      );

  void save() {
    if (controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter employee name'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    } else if (selectedRole.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select role'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    } else if (date1.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select 1st date'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    } else {
      if (widget.employee != null) {
        context.read<EmployeeBloc>().add(
              UpdateEmployee(widget.employee!.copyWith(
                name: controller.text,
                role: selectedRole.value!,
                dateTime1: date1.value!,
                dateTime2: date2.value,
              )),
            );
      } else {
        context.read<EmployeeBloc>().add(
              CreateEmployee(Employee(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: controller.text,
                role: selectedRole.value!,
                dateTime1: date1.value!,
                dateTime2: date2.value,
              )),
            );
      }
      Navigator.pop(context);
    }
  }
}
