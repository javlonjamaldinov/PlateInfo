import 'package:car_number/src/data/database_helper.dart';
import 'package:car_number/src/presentation/page/car_info_page.dart';
import 'package:car_number/src/repository/car_repository.dart';
import 'package:car_number/src/usecase/fetch_car_info.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = DatabaseHelper.openDb();
  final carRepository = CarRepository(database: database);
  await carRepository.loadCsvData();

  runApp(MyApp(fetchCarInfo: FetchCarInfo(repository: carRepository)));
}

class MyApp extends StatelessWidget {
  final FetchCarInfo fetchCarInfo;

  const MyApp({super.key, required this.fetchCarInfo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: CarInfoPage(fetchCarInfo: fetchCarInfo),
    );
  }
}
