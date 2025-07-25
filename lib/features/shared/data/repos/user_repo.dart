import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UsersRepo {
  final String baseUrl = 'https://enterra-api.onrender.com';
  final String? token;

  UsersRepo({this.token});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  Future<List<User>> getUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> getUserById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$id'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('User not found');
    }
  }

  Future<User> getUserByName(String name) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/name/$name'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('User not found');
    }
  }

  Future<List<User>> getUserByCompanyId(String companyId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/company/$companyId'),
      headers: _headers,
    );
    if(response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get user by companyId');
    }
  }

  Future<User> updateUser(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: _headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$id'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  Future<List<User>> searchUser(String part) async {

    final response = await http.get(
      Uri.parse('$baseUrl/users/search/').replace(
        queryParameters: {'part': part},
      ),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to search users ${response.statusCode} ${response.body}');
    }
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => User.fromJson(e)).toList();
  }
}
