import 'package:car_number/src/data/csv_loader.dart';
import 'package:sqflite/sqflite.dart';
import '../data/database_helper.dart';

class CarRepository {
  final Future<Database> database;

  CarRepository({required this.database});

  // Method to load CSV data into the database
  Future<void> loadCsvData() async {
    final db = await database; // Await the database instance
    await CsvLoader.loadCsvData(db); // Load CSV data into the database
  }

  // Method to retrieve car information based on the car number
  Future<List<Map<String, dynamic>>> getCarInfo(String carNumber) async {
    final db = await database; // Await the database instance
    return DatabaseHelper.getCarByNumber(db, carNumber); // Query the database for car info
  }
}
