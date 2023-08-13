// import 'package:get_it/get_it.dart';

// import 'repository/box_repository.dart';

// final getIt = GetIt.instance;

// Future<void> setupLocator() async {
//   getIt.registerLazySingletonAsync<BoxRepository>(
//     () async {
//       final boxRepository = BoxRepository();
//       await boxRepository.init();
//       return boxRepository;
//     },
//     dispose: (param) async => await param.close(),
//   );

//   await getIt.allReady();
// }
