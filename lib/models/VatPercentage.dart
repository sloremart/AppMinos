class VatPercentage {
  final int? id;
  final double percentage;
  final String description;

  VatPercentage({this.id, required this.percentage, required this.description});

  factory VatPercentage.fromMap(Map<String, dynamic> map) {
    return VatPercentage(
      id: map['id'],
      percentage: map['percentage'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'percentage': percentage,
      'description': description,
    };
  }
}
