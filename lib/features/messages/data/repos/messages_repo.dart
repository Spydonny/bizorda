import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message.dart';
import '../models/message_room.dart';

class MessagesRepo {
  final String baseUrl = 'https://enterra-api.onrender.com/messages';
  final String token;

  MessagesRepo({required this.token});

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  /// Create or retrieve message room
  Future<MessageRoom> createRoom({
    required bool isGroup,
    required List<String> participants,
    String? name,
  }) async {
    final uri = Uri.parse('$baseUrl/');
    final body = jsonEncode({
      'is_group': isGroup,
      'participants': participants,
      'name': name,
    });

    final res = await http.post(uri, headers: _headers, body: body);

    if (res.statusCode != 200) {
      throw Exception('Failed to create room: ${res.body}');
    }

    return MessageRoom.fromJson(jsonDecode(res.body));
  }

  Future<List<MessageRoom>> getRooms() async {
    final uri = Uri.parse('$baseUrl/');
    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('Failed to get room: ${res.body}');
    }

    final List<dynamic> data = jsonDecode(res.body);
    return data.map((e) => MessageRoom.fromJson(e)).toList();
  }

  /// Create a message with optional image
  Future<Message> sendMessage({
    required String roomId,
    required String content,
    String? imageFilePath,
  }) async {
    final uri = Uri.parse('$baseUrl/$roomId');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['content'] = content;

    if (imageFilePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFilePath));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception('Failed to send message: ${response.body}');
    }

    return Message.fromJson(jsonDecode(response.body));
  }

  /// List messages from a room
  Future<List<Message>> getMessages(String roomId) async {
    final uri = Uri.parse('$baseUrl/$roomId');
    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('Failed to get messages: ${res.body}');
    }

    final List<dynamic> data = jsonDecode(res.body);
    return data.map((e) => Message.fromJson(e)).toList();
  }

  /// Read a single message
  Future<Message> getMessage(String roomId, String messageId) async {
    final uri = Uri.parse('$baseUrl/$roomId/$messageId');
    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('Message not found: ${res.body}');
    }

    return Message.fromJson(jsonDecode(res.body));
  }

  /// Read the last message
  Future<Message> getLastMessage(String roomId, String messageId) async {
    final uri = Uri.parse('$baseUrl/$roomId/$messageId/last');
    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('Message not found: ${res.body}');
    }

    return Message.fromJson(jsonDecode(res.body));
  }

  /// Mark message as read
  Future<void> markMessageRead({
    required String roomId,
    required String messageId,
  }) async {
    final uri = Uri.parse('$baseUrl/messages/$roomId/$messageId');
    final response = await http.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark message as read');
    }
  }

  /// Update a message
  Future<Message> updateMessage({
    required String roomId,
    required String messageId,
    required Map<String, dynamic> updates,
  }) async {
    final uri = Uri.parse('$baseUrl/$roomId/$messageId');
    final res = await http.put(
      uri,
      headers: _headers,
      body: jsonEncode(updates),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to update message: ${res.body}');
    }

    return Message.fromJson(jsonDecode(res.body));
  }

  /// Delete a message
  Future<void> deleteMessage(String roomId, String messageId) async {
    final uri = Uri.parse('$baseUrl/$roomId/$messageId');
    final res = await http.delete(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('Failed to delete message: ${res.body}');
    }
  }
}
