import 'dart:convert';

import 'package:flutter/foundation.dart';

class TeamMember {
  final String id;
  final String userId;
  final String teamId;
  final String name;
  final String email;
  final int invited;
  final int joined;
  final bool confirm;
  final List<String> roles;
  TeamMember({
    required this.id,
    required this.userId,
    required this.teamId,
    required this.name,
    required this.email,
    required this.invited,
    required this.joined,
    required this.confirm,
    required this.roles,
  });

  TeamMember copyWith({
    String? id,
    String? userId,
    String? teamId,
    String? name,
    String? email,
    int? invited,
    int? joined,
    bool? confirm,
    List<String>? roles,
  }) {
    return TeamMember(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      teamId: teamId ?? this.teamId,
      name: name ?? this.name,
      email: email ?? this.email,
      invited: invited ?? this.invited,
      joined: joined ?? this.joined,
      confirm: confirm ?? this.confirm,
      roles: roles ?? this.roles,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'teamId': teamId,
      'name': name,
      'email': email,
      'invited': invited,
      'joined': joined,
      'confirm': confirm,
      'roles': roles,
    };
  }

  factory TeamMember.fromMap(Map<String, dynamic> map) {
    return TeamMember(
      id: map['\$id'],
      userId: map['userId'],
      teamId: map['teamId'],
      name: map['name'],
      email: map['email'],
      invited: map['invited'],
      joined: map['joined'],
      confirm: map['confirm'],
      roles: List<String>.from(map['roles'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory TeamMember.fromJson(String source) => TeamMember.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TeamMember(id: $id, userId: $userId, teamId: $teamId, name: $name, email: $email, invited: $invited, joined: $joined, confirm: $confirm, roles: $roles)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TeamMember &&
      other.id == id &&
      other.userId == userId &&
      other.teamId == teamId &&
      other.name == name &&
      other.email == email &&
      other.invited == invited &&
      other.joined == joined &&
      other.confirm == confirm &&
      listEquals(other.roles, roles);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      teamId.hashCode ^
      name.hashCode ^
      email.hashCode ^
      invited.hashCode ^
      joined.hashCode ^
      confirm.hashCode ^
      roles.hashCode;
  }
}
