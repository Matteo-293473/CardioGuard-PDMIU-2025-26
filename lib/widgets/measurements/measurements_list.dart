import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/measurement.dart';
import '../../providers/providers.dart';

class MeasurementsList extends ConsumerWidget {
  const MeasurementsList({super.key});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conferma'),
        content: const Text('Vuoi davvero eliminare questa misurazione?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annulla')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Elimina')),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(measurementListProvider.notifier).removeMeasurement(id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measurementsAsync = ref.watch(measurementListProvider);

    return measurementsAsync.when(
      data: (measurements) {
        if (measurements.isEmpty) {
          return const Center(
            child: Text('Nessuna misurazione salvata.'),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: measurements.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final m = measurements[index];
            final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(m.timestamp);
            
            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.favorite, color: Colors.red),
              ),
              title: Text('${m.systolic}/${m.diastolic} mmHg'),
              subtitle: Text('$dateStr - ${m.pulse} BPM'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _confirmDelete(context, ref, m.id!),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Si è verificato un errore nel caricamento dei dati.')),
    );
  }
}