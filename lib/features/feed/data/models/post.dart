class Post {
  final String id;
  final String content;
  final String? image;
  final String senderId;
  final String senderName;
  final String companyId;
  final String companyName;
  final DateTime timestamp;
  final int likes;
  final List<String> idsLiked;

  Post({
    required this.id,
    required this.content,
    this.image,
    required this.senderId,
    required this.senderName,
    required this.companyId,
    required this.companyName,
    required this.timestamp,
    required this.likes,
    required this.idsLiked
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['id'],
    content: json['content'],
    image: json['image'],
    senderId: json['sender_id'],
    senderName: json['sender_name'],
    companyId: json['company_id'],
    companyName: json['company_name'],
    timestamp: DateTime.parse(json['timestamp']),
    likes: json['likes'],
    idsLiked: (json['ids_liked'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'image': image,
      'sender_id': senderId,
      'sender_name': senderName,
      'company_id': companyId,
      'company_name': companyName,
      'timestamp': timestamp.toIso8601String(),
      'likes': likes,
      'ids_liked': idsLiked
    };
  }

}
