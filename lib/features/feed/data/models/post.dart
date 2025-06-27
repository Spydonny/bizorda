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
  );
}
