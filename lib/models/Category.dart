// ignore: file_names
class Category {
  final int? id;
  final String name;
  final String description;

  // Constructor
  Category({this.id, required this.name, required this.description});

  // Convertir de Map a objeto Category
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  // Convertir de objeto Category a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
