import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'bloc/employee_bloc.dart';
import 'data/models/employee_model.dart';
import 'repository/box_repository.dart';
import 'screens/home/home.dart';

Future<void> get init async {
  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeAdapter());
  Hive.registerAdapter(EmployeeRoleAdapter());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init;
  runApp(const EmployeeApp());
}

class EmployeeApp extends StatelessWidget {
  const EmployeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final boxRepo = BoxRepository();
    return RepositoryProvider(
      create: (context) => boxRepo,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                EmployeeBloc(RepositoryProvider.of<BoxRepository>(context))
                  ..add(LoadEmployees()),
          )
        ],
        child: MaterialApp(
          title: 'Employee App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              useMaterial3: false,
              primaryColor: const Color.fromRGBO(29, 161, 242, 1)),
          home: FutureBuilder<void>(
              future: boxRepo.init(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      )
                    : const Home();
              }),
        ),
      ),
    );
  }
}
