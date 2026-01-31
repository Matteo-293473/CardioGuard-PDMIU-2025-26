// widget visualizzazione dati utente
import 'package:flutter/material.dart';
import '../../data/models/user.dart';

class UserProfileReadInfo extends StatelessWidget {
  final User user;
  const UserProfileReadInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.person),
          title: const Text("Nome"),
          subtitle: Text(user.name, style: const TextStyle(fontSize: 16)),
        ),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.cake),
                title: const Text("Età"),
                subtitle: Text("${user.age} anni"),
              ),
            ),
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.wc),
                title: const Text("Sesso"),
                subtitle: Text(user.sex == 1 ? "Maschio" : "Femmina"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
