class Company {
  final String id;
  final String name;
  final String email;
  final String sphere;
  final String OKED;
  final String? description;
  final String? website;
  final String? location;
  final String? phoneNumber;
  final String? logo;

  Company({
    required this.id,
    required this.name,
    required this.email,
    required this.sphere,
    required this.OKED,
    this.description,
    this.website,
    this.location,
    this.phoneNumber,
    this.logo,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      sphere: json['sphere'],
      OKED: json['OKED'],
      description: json['description'],
      website: json['website'],
      location: json['location'],
      phoneNumber: json['phone_number'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'sphere': sphere,
      'OKED': OKED,
      'description': description,
      'website': website,
      'location': location,
      'phone_number': phoneNumber,
      'logo': logo,
    };
  }

  Company copyWith({
    String? id,
    String? name,
    String? email,
    String? sphere,
    String? OKED,
    String? description,
    String? website,
    String? location,
    String? phoneNumber,
    String? logo,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      sphere: sphere ?? this.sphere,
      OKED: OKED ?? this.OKED,
      description: description ?? this.description,
      website: website ?? this.website,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      logo: logo ?? this.logo,
    );
  }
}
