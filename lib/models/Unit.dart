class Unit {
  final int? id;
  final String name;
  final String abbreviation;

  Unit({this.id, required this.name, required this.abbreviation});

  factory Unit.fromMap(Map<String, dynamic> map) {
    return Unit(
      id: map['id'],
      name: map['name'],
      abbreviation: map['abbreviation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'abbreviation': abbreviation,
    };
  }
}
