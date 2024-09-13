class Dustbin {
  Dustbin({
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  final String name;
  final String type;
  final double latitude;
  final double longitude;

  factory Dustbin.fromJson(Map json) {
    return Dustbin(
      name: json['name'] ?? 'unknown',
      type: json['type'],
      latitude: json['lat'],
      longitude: json['lng'],
    );
  }
}
