import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String companyId;
  final String fullname;
  final String nationalId;
  final String position;
  final String? avatar;

  const User({
    required this.id,
    required this.companyId,
    required this.fullname,
    required this.nationalId,
    required this.position,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      companyId: json['company_id'] as String,
      fullname: json['fullname'] as String,
      nationalId: json['NationalID'] as String,
      position: json['position'] as String,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'fullname': fullname,
      'NationalID': nationalId,
      'position': position,
      'avatar': avatar,
    };
  }

  User copyWith({
    String? id,
    String? companyId,
    String? fullname,
    String? nationalId,
    String? position,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      fullname: fullname ?? this.fullname,
      nationalId: nationalId ?? this.nationalId,
      position: position ?? this.position,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  List<Object?> get props => [id, companyId, fullname, nationalId, position, avatar];
}
