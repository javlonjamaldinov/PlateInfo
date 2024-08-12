import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class CsvLoader {
  // Method to load CSV data into the SQLite database
  static Future<void> loadCsvData(Database db) async {
    try {
      // Load CSV file from assets folder
      final csvData = await rootBundle.loadString('assets/car_info.csv');
      
      // Convert CSV data to a list of rows
      List<List<dynamic>> rows = const CsvToListConverter().convert(csvData);

      // Iterate through each row (starting from index 1 to skip header)
      for (int i = 1; i < rows.length; i++) {
        // Create a map representing a car's data
        final car = {
          'carNumber': rows[i][0].toString(),
          'driverName': rows[i][1].toString(),
          'registrationDate': rows[i][2].toString(),
          'registrationPlace': rows[i][3].toString(),
        };

        // Insert the car data into the database
        await DatabaseHelper.insertCar(db, car);
      }
    } catch (e) {
      // Handle any errors during the CSV loading process
      print('Error loading CSV: $e');
    }
  }
}
