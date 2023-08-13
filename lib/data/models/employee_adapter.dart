// import 'package:employee/data/models/employee_model.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// class EmployeeAdapter extends TypeAdapter<Employee> {
//   @override
//   Employee read(BinaryReader reader) {
//     return Employee(
//       id: reader.read(),
//       name: reader.read(),
//       role: EmployeeRole.values[reader.read()],
//       dateTime1: reader.read(),
//       dateTime2: reader.read(),
//     );
//   }

//   @override
//   int get typeId => 1;

//   @override
//   void write(BinaryWriter writer, Employee obj) {
//     writer.write(obj.id);
//     writer.write(obj.name);
//     writer.write(obj.role.index);
//     writer.write(obj.dateTime1);
//   }
// }
