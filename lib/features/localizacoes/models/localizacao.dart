class Localizacao {
  final int? id;
  final double latitude;
  final double longitude;
  final double precisao;
  final DateTime instante;

  Localizacao({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.precisao,
    required this.instante,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'precisao': precisao,
      'instante': instante.toUtc().toIso8601String(), // Armazena em UTC
    };
  }

  factory Localizacao.fromMap(Map<String, dynamic> map) {
    return Localizacao(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      precisao: map['precisao'],
      instante: DateTime.parse(map['instante']).toLocal(), // Converte para horário local
    );
  }
}