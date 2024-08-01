class Item {
  String id;
  String marca;
  String modelo;
  String tipo;
  String material;

  Item({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.tipo,
    required this.material,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      marca: json['marca'],
      modelo: json['modelo'],
      tipo: json['tipo'],
      material: json['material'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'marca': marca,
      'modelo': modelo,
      'tipo': tipo,
      'material': material,
    };
  }
}
