import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/measurement.dart';
import '../data/repositories/measurement_repository.dart';

// provider measurement repository
final measurementRepositoryProvider = Provider<MeasurementRepository>((ref) {
  return MeasurementRepository();
});

// asyncNotifier lista misurazioni
class MeasurementListNotifier extends AsyncNotifier<List<Measurement>> {
  @override
  Future<List<Measurement>> build() async {
    final repo = ref.watch(measurementRepositoryProvider);
    return repo.getAllMeasurements();
  }

  Future<void> addMeasurement(Measurement measurement) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(measurementRepositoryProvider);
      await repo.insertMeasurement(measurement);
      return repo.getAllMeasurements();
    });
  }

  Future<void> removeMeasurement(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(measurementRepositoryProvider);
      await repo.deleteMeasurement(id);
      return repo.getAllMeasurements();
    });
  }
}

final measurementListProvider = AsyncNotifierProvider<MeasurementListNotifier, List<Measurement>>(() {
  return MeasurementListNotifier();
});
