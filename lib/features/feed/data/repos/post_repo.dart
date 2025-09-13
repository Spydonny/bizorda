import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart'; // для kIsWeb

import '../models/post.dart';

class PostRepository {
  final String baseUrl = 'https://enterra-api-production.up.railway.app';
  final String token;

  PostRepository({ required this.token});

  Map<String, String> get _headers => {
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };

  Future<Post> createPost(String content, {XFile? imageFile}) async {
    final uri = Uri.parse('$baseUrl/company/posts/');
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(_headers)
      ..fields['content'] = content;

    if (imageFile != null) {
      final mimeType = lookupMimeType(imageFile.path) ?? 'image/png';
      final mediaType = MediaType.parse(mimeType);

      if (kIsWeb) {
        // 🔹 Web: берем bytes напрямую
        final bytes = await imageFile.readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: imageFile.name,
          contentType: mediaType,
        );
        request.files.add(multipartFile);
      } else {
        // 🔹 Android/iOS/desktop: через stream
        final fileStream = http.ByteStream(imageFile.openRead());
        final fileLength = await imageFile.length();
        final multipartFile = http.MultipartFile(
          'image',
          fileStream,
          fileLength,
          filename: imageFile.path.split('/').last,
          contentType: mediaType,
        );
        request.files.add(multipartFile);
      }
    }

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Ошибка загрузки: ${response.statusCode}');
    }

    final responseData = await response.stream.bytesToString();
    return Post.fromJson(jsonDecode(responseData));
  }

  Future<List<Post>> getAllPosts() async {
    final uri = Uri.parse('$baseUrl/company/posts/');
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch posts');
    }
  }

  Future<List<Post>> getPostsByCompany(String companyId) async {
    final uri = Uri.parse('$baseUrl/company/posts/$companyId');
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch company posts');
    }
  }

  Future<Post> getPostById(String postId) async {
    final uri = Uri.parse('$baseUrl/company/posts/$postId');
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Post not found');
    }
  }

  Future<Post> updatePost(String postId, Map<String, dynamic> updates) async {
    final uri = Uri.parse('$baseUrl/company/posts/$postId');
    final response = await http.put(
      uri,
      headers: {
        ..._headers,
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(updates),
    );

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update post');
    }
  }

  Future<void> deletePost(String postId) async {
    final uri = Uri.parse('$baseUrl/company/posts/$postId');
    final response = await http.delete(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete post');
    }
  }

  Future<Post> likePost(String postId, String userId) async {
    // Формируем URI с query-параметром
    final uri = Uri.parse('$baseUrl/company/posts/$postId/like')
        .replace(queryParameters: {'user_id': userId});

    final response = await http.post(
      uri,
      headers: _headers,
      // body больше не нужен, т.к. данные передаем в query
    );

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to like post');
    }
  }
}
