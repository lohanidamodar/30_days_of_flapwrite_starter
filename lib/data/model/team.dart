import 'dart:convert';

class Team {
  final String id;
  final String name;
  final int sum;
  final int dateCreated;
  Team({
    required this.id,
    required this.name,
    required this.sum,
    required this.dateCreated,
  });

  Team copyWith({
    String? id,
    String? name,
    int? sum,
    int? dateCreated,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      sum: sum ?? this.sum,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sum': sum,
      'dateCreated': dateCreated,
    };
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['\$id'],
      name: map['name'],
      sum: map['sum'],
      dateCreated: map['dateCreated'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Team.fromJson(String source) => Team.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Team(id: $id, name: $name, sum: $sum, dateCreated: $dateCreated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Team &&
      other.id == id &&
      other.name == name &&
      other.sum == sum &&
      other.dateCreated == dateCreated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      sum.hashCode ^
      dateCreated.hashCode;
  }
}
