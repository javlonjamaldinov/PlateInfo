import '../repository/car_repository.dart';

class FetchCarInfo {
  final CarRepository repository;

  // Constructor for FetchCarInfo, initializing the repository
  FetchCarInfo({required this.repository});

  // Method to fetch car information using the repository
  Future<List<Map<String, dynamic>>> call(String carNumber) async {
    // Retrieve car information from the repository based on the car number
    return repository.getCarInfo(carNumber);
  }
}
