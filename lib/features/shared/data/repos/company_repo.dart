import 'dart:convert';
import 'dart:io';

import 'package:bizorda/features/shared/data/models/company.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';


class CompanyRepository {
  final String baseUrl = 'https://enterra-api.onrender.com';


  // CREATE
  Future<Company?> createCompany({
    required String name,
    required String email,
    required String sphere,
    required String OKED,
    String? description,
    String? website,
    String? location,
    String? phoneNumber,
    File? logoFile,
  }) async {
    final uri = Uri.parse('$baseUrl/companies/');
    final request = http.MultipartRequest('POST', uri);

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['sphere'] = sphere;
    request.fields['OKED'] = OKED;

    if (description != null) request.fields['description'] = description;
    if (website != null) request.fields['website'] = website;
    if (location != null) request.fields['location'] = location;
    if (phoneNumber != null) request.fields['phoneNumber'] = phoneNumber;

    if (logoFile != null) {
      final mimeType = lookupMimeType(logoFile.path) ?? 'application/octet-stream';
      final mimeSplit = mimeType.split('/');
      request.files.add(
        await http.MultipartFile.fromPath(
          'logo',
          logoFile.path,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
          filename: basename(logoFile.path),
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Company.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw ArgumentError('Failed to create company: found other with the same name ${response.body}');
    } else {
      throw Exception('Failed to create company: ${response.statusCode} ${response.body}');
    }
  }

  // GET ALL
  Future<List<Map<String, dynamic>>> listCompanies() async {
    final uri = Uri.parse('$baseUrl/companies/');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load companies');
    }
  }

  // GET BY ID
  Future<Company> getCompanyById(String companyId) async {
    final uri = Uri.parse('$baseUrl/companies/id/$companyId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return Company.fromJson(json.decode(response.body));
    } else {
      throw Exception('Company not found');
    }
  }

  // GET BY name
  Future<Map<String, dynamic>> getCompanyByName(String companyName) async {
    final uri = Uri.parse('$baseUrl/companies/name/$companyName');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Company not found');
    }
  }

  // UPDATE
  Future<Map<String, dynamic>> updateCompany({
    required String companyId,
    required Map<String, dynamic> data,
  }) async {
    final uri = Uri.parse('$baseUrl/companies/$companyId');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update company');
    }
  }

  // DELETE
  Future<void> deleteCompany(String companyId) async {
    final uri = Uri.parse('$baseUrl/companies/$companyId');
    final response = await http.delete(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete company');
    }
  }
}
