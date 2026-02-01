// widget lista scrollabile storico misurazioni
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/providers.dart';

class MeasurementsList extends ConsumerWidget {
  const MeasurementsList({super.key});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, int id) async {
    // mostriamo la dialog di conferma
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conferma'),
        content: const Text('Vuoi davvero eliminare questa misurazione?'),
        actions: [
          // restituisce un booleano in base alla scelta dell'utente
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annulla')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Elimina')),
        ],
      ),
    );

    // se l'utente ha confermato l'eliminazione
    // si chiama il metodo removeMeasurement del provider
    if (confirmed == true) {
      await ref.read(measurementListProvider.notifier).removeMeasurement(id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ci serve lo stato del provider per visualizzare le misurazioni
    final measurementsAsync = ref.watch(measurementListProvider);

    return measurementsAsync.when(
      data: (measurements) {
        if (measurements.isEmpty) {
          return const Center(
            child: Text('Nessuna misurazione salvata.'),
          );
        }

        // misurazioni salvate
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: measurements.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final m = measurements[index];
            final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(m.timestamp);
            
            // per ogni misurazione creiamo una ListTile
            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.favorite, color: Colors.red),
              ),
              title: Text('${m.systolic}/${m.diastolic} mmHg - ${m.pulse} BPM'),
              subtitle: Text(dateStr),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                // premo l'icon del cestino
                onPressed: () => _confirmDelete(context, ref, m.id!),
              ),
            );
          },
        );
      },
      // gestisco gli altri casi dell'asyncValue
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const Center(child: Text('Si è verificato un errore nel caricamento dei dati.')),
    );
  }
}