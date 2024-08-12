import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Method to open or create the database
  static Future<Database> openDb() async {
    return openDatabase(
      // Define the path for the database file
      join(await getDatabasesPath(), 'car_info.db'),
      onCreate: (db, version) {
        // Create the 'cars' table when the database is first created
        return db.execute(
          "CREATE TABLE cars(id INTEGER PRIMARY KEY AUTOINCREMENT, carNumber TEXT UNIQUE, driverName TEXT, registrationDate TEXT, registrationPlace TEXT)",
        );
      },
      version: 1, // Database version
    );
  }

  // Method to insert a car record into the 'cars' table
  static Future<void> insertCar(Database db, Map<String, dynamic> car) async {
    await db.insert(
      'cars',
      car,
      conflictAlgorithm: ConflictAlgorithm.replace, // Replace existing record if there's a conflict
    );
  }

  // Method to retrieve car records by car number
  static Future<List<Map<String, dynamic>>> getCarByNumber(Database db, String carNumber) async {
    return await db.query(
      'cars',
      where: "carNumber = ?", // SQL query condition
      whereArgs: [carNumber.toUpperCase()], // Value to be used in the condition
    );
  }
}
