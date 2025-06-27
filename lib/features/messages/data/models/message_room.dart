class MessageRoom {
  final String id;
  final bool isGroup;
  final String? name;
  final List<String> participants;
  final DateTime createdAt;

  MessageRoom({
    required this.id,
    required this.isGroup,
    this.name,
    required this.participants,
    required this.createdAt,
  });

  factory MessageRoom.fromJson(Map<String, dynamic> json) {
    return MessageRoom(
      id: json['id'] as String,
      isGroup: json['is_group'] as bool,
      name: json['name'] as String?,
      participants: List<String>.from(json['participants'] ?? []),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_group': isGroup,
      'name': name,
      'participants': participants,
      'created_at': createdAt.toIso8601String(),
    };
  }

  MessageRoom copyWith({
    String? id,
    bool? isGroup,
    String? name,
    List<String>? participants,
    DateTime? createdAt,
  }) {
    return MessageRoom(
      id: id ?? this.id,
      isGroup: isGroup ?? this.isGroup,
      name: name ?? this.name,
      participants: participants ?? this.participants,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
