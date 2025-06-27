class Message {
  final String id;
  final String content;
  final String? image;
  final String senderId;
  final DateTime timestamp;
  final String status;

  Message({
    required this.id,
    required this.content,
    this.image,
    required this.senderId,
    required this.timestamp,
    required this.status,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      content: json['content'] as String,
      image: json['image'] as String?,
      senderId: json['sender_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'image': image,
      'sender_id': senderId,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }

  Message copyWith({
    String? id,
    String? content,
    String? image,
    String? senderId,
    DateTime? timestamp,
    String? status,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      image: image ?? this.image,
      senderId: senderId ?? this.senderId,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}
