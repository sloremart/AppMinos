import 'package:minosapp/helpers/database_helper.dart';
import 'package:minosapp/models/Subgroup.dart';

class Group {
  final int? id;
  final String name;
  final String description;
  final String code;
  List<Subgroup>? subgroups;

  Group({this.id, required this.name, required this.description, required this.code, this.subgroups});

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      code: map['code'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'code': code,
    };
  }

  Future<void> loadSubgroups(DatabaseHelper dbHelper) async {
    this.subgroups = (await dbHelper.getSubgroupsByGroupId(this.id!)).cast<Subgroup>();
  }
}
