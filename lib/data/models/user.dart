// modello dati per le informazioni dell'utente + metodi per conversione
import 'dart:convert';

class User {
  final String name;
  final int age;
  final int sex;

  User({
    required this.name,
    required this.age,
    required this.sex,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'sex': sex,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      age: map['age']?.toInt() ?? 0,
      sex: map['sex']?.toInt() ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
