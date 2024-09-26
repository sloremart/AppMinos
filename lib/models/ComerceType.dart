class CommerceType {
  final int? id;
  final String name;

  CommerceType({this.id, required this.name});

  factory CommerceType.fromMap(Map<String, dynamic> map) {
    return CommerceType(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
