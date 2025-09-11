import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../../shared/data/models/user.dart';
import '../../../../exceptions/exceptions.dart';


class AuthRepository {
  final baseUrl = 'https://enterra-api-production.up.railway.app';

  Future<String> login({
    required String nationalID,
    required String password,
  }) async
  {
    final uri = Uri.parse('$baseUrl/token');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'password',
        'username': nationalID,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Login failed: ${response.statusCode} ${response.body}');
    }
  }

  // REGISTER USER
  Future<User> registerUser({
    required String companyId,
    required String fullname,
    required String nationalId,
    required String position,
    required String password,
    File? avatarFile,
  })
  async {
    final uri = Uri.parse('$baseUrl/register');
    final request = http.MultipartRequest('POST', uri);

    request.fields['company_id'] = companyId;
    request.fields['fullname'] = fullname;
    request.fields['NationalID'] = nationalId;
    request.fields['position'] = position;
    request.fields['password'] = password;

    if (avatarFile != null) {
      final mimeType = lookupMimeType(avatarFile.path) ?? 'application/octet-stream';
      final mimeSplit = mimeType.split('/');
      request.files.add(
        await http.MultipartFile.fromPath(
          'avatar',
          avatarFile.path,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
          filename: basename(avatarFile.path),
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw FoundOtherException('This IIN is already registered');
    } else {
      throw Exception('Failed to register user: ${response.statusCode} ${response.body}');
    }
  }

  // GET CURRENT USER (Protected route)
  Future<User?> getCurrentUser(String accessToken) async {
    final uri = Uri.parse('$baseUrl/protected');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get current user: ${response.statusCode}');
    }
  }

  Future<bool> checkAuth(String token) async {
    final uri = Uri.parse('$baseUrl/protected');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }
}
