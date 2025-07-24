class Company {
  final String id;
  final String name;
  final String email;
  final String sphere;
  final String OKED;
  final String typeOrg;
  final String typeOfRegistration;
  final String? status;
  final String? description;
  final String? website;
  final String? location;
  final String? phoneNumber;
  final String? logo;

  final String? businessModel;
  final String? investmentRound;
  final double? investmentRequired;
  final double? investmentOffered;
  final double? income;
  final int? clients;
  final double? midReceipt;
  final double? CAC;
  final double? LTV;
  final double? totalRevenue;

  Company({
    required this.id,
    required this.name,
    required this.email,
    required this.sphere,
    required this.OKED,
    required this.typeOrg,
    required this.typeOfRegistration,
    this.status,
    this.description,
    this.website,
    this.location,
    this.phoneNumber,
    this.logo,
    this.businessModel,
    this.investmentRound,
    this.investmentRequired,
    this.investmentOffered,
    this.income,
    this.clients,
    this.midReceipt,
    this.CAC,
    this.LTV,
    this.totalRevenue,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      sphere: json['sphere'],
      OKED: json['OKED'],
      typeOrg: json['typeOrg'],
      typeOfRegistration: json['type_of_registration'],
      status: json['status'],
      description: json['description'],
      website: json['website'],
      location: json['location'],
      phoneNumber: json['phone_number'],
      logo: json['logo'],
      businessModel: json['business_model'],
      investmentRound: json['investment_round'],
      investmentRequired: (json['investment_required'] as num?)?.toDouble(),
      investmentOffered: (json['investment_offered'] as num?)?.toDouble(),
      income: (json['income'] as num?)?.toDouble(),
      clients: json['clients'],
      midReceipt: (json['mid_receipt'] as num?)?.toDouble(),
      CAC: (json['CAC'] as num?)?.toDouble(),
      LTV: (json['LTV'] as num?)?.toDouble(),
      totalRevenue: (json['total_revenue'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'sphere': sphere,
      'OKED': OKED,
      'typeOrg': typeOrg,
      'type_of_registration': typeOfRegistration,
      'status': status,
      'description': description,
      'website': website,
      'location': location,
      'phone_number': phoneNumber,
      'logo': logo,
      'business_model': businessModel,
      'investment_round': investmentRound,
      'investment_required': investmentRequired,
      'investment_offered': investmentOffered,
      'income': income,
      'clients': clients,
      'mid_receipt': midReceipt,
      'CAC': CAC,
      'LTV': LTV,
      'total_revenue': totalRevenue,
    };
  }

  Company copyWith({
    String? id,
    String? name,
    String? email,
    String? sphere,
    String? OKED,
    String? typeOrg,
    String? typeOfRegistration,
    String? status,
    String? description,
    String? website,
    String? location,
    String? phoneNumber,
    String? logo,
    String? businessModel,
    String? investmentRound,
    double? investmentRequired,
    double? investmentOffered,
    double? income,
    int? clients,
    double? midReceipt,
    double? CAC,
    double? LTV,
    double? totalRevenue,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      sphere: sphere ?? this.sphere,
      OKED: OKED ?? this.OKED,
      typeOrg: typeOrg ?? this.typeOrg,
      typeOfRegistration: typeOfRegistration ?? this.typeOfRegistration,
      status: status ?? this.status,
      description: description ?? this.description,
      website: website ?? this.website,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      logo: logo ?? this.logo,
      businessModel: businessModel ?? this.businessModel,
      investmentRound: investmentRound ?? this.investmentRound,
      investmentRequired: investmentRequired ?? this.investmentRequired,
      investmentOffered: investmentOffered ?? this.investmentOffered,
      income: income ?? this.income,
      clients: clients ?? this.clients,
      midReceipt: midReceipt ?? this.midReceipt,
      CAC: CAC ?? this.CAC,
      LTV: LTV ?? this.LTV,
      totalRevenue: totalRevenue ?? this.totalRevenue,
    );
  }


}

