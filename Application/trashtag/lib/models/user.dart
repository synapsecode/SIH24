// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final int id;
  final String name;
  final String username;
  final double points;

  User(
      {required this.id,
      required this.name,
      required this.username,
      required this.points});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'username': username,
      'points': points,
    };
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      name: map['name'] as String,
      username: map['username'] as String,
      points: map['points'] as double,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
