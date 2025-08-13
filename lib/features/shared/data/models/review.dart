class Review {
  final String id;
  final String content;
  final int rating;
  final String reviewerId;
  final String reviewerName;
  final String companyId;
  final DateTime timestamp;

  Review({
    required this.id,
    required this.content,
    required this.rating,
    required this.reviewerId,
    required this.reviewerName,
    required this.companyId,
    required this.timestamp,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      content: json['content'],
      rating: json['rating'],
      reviewerId: json['reviewer_id'],
      reviewerName: json['reviewer_name'],
      companyId: json['company_id'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'rating': rating,
      'reviewer_id': reviewerId,
      'reviewer_name': reviewerName,
      'company_id': companyId,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Создаёт копию объекта с изменёнными полями
  Review copyWith({
    String? id,
    String? content,
    int? rating,
    String? reviewerId,
    String? reviewerName,
    String? companyId,
    DateTime? timestamp,
  }) {
    return Review(
      id: id ?? this.id,
      content: content ?? this.content,
      rating: rating ?? this.rating,
      reviewerId: reviewerId ?? this.reviewerId,
      reviewerName: reviewerName ?? this.reviewerName,
      companyId: companyId ?? this.companyId,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
