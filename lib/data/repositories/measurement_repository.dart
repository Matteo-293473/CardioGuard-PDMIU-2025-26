import '../models/measurement.dart';
import '../database/database_service.dart';

class MeasurementRepository {
  final DatabaseService _dbService = DatabaseService();

  Future<int> insertMeasurement(Measurement measurement) async {
    final db = await _dbService.database;
    return await db.insert('measurements', measurement.toMap());
  }

  Future<List<Measurement>> getAllMeasurements() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'measurements',
      orderBy: 'timestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return Measurement.fromMap(maps[i]);
    });
  }

  Future<int> deleteMeasurement(int id) async {
    final db = await _dbService.database;
    return await db.delete(
      'measurements',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
