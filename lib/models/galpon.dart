class Galpon {
  final int id;
  final String nombre;

  Galpon({required this.id, required this.nombre});

  factory Galpon.fromJson(Map<String, dynamic> json) {
    return Galpon(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}
