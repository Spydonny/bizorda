import 'dart:convert';
import 'dart:io';

import 'package:bizorda/features/shared/data/models/company.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';


class CompanyRepository {
  final String baseUrl = 'https://enterra-api-production.up.railway.app';


  // CREATE
  Future<Company?> createCompany({
    required String name,
    required String email,
    required String sphere,
    required String OKED,
    String typeOrg = 'Стартап',
    required String registrationType,
    String status = 'free',
    String? description,
    String? website,
    String? location,
    String? phoneNumber,
    File? logoFile,
  }) async
  {
    final uri = Uri.parse('$baseUrl/companies/');
    final request = http.MultipartRequest('POST', uri);

    // Обязательные поля
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['sphere'] = sphere;
    request.fields['OKED'] = OKED;
    request.fields['type_org'] = typeOrg;
    request.fields['type_of_registration'] = registrationType;
    request.fields['status'] = status;

    // Необязательные поля
    if (description != null) request.fields['description'] = description;
    if (website != null) request.fields['website'] = website;
    if (location != null) request.fields['location'] = location;
    if (phoneNumber != null) request.fields['phoneNumber'] = phoneNumber;

    // Логотип
    if (logoFile != null) {
      final mimeType = lookupMimeType(logoFile.path) ?? 'application/octet-stream';
      final parts = mimeType.split('/');
      request.files.add(await http.MultipartFile.fromPath(
        'logo',
        logoFile.path,
        contentType: MediaType(parts[0], parts[1]),
        filename: basename(logoFile.path),
      ));
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return Company.fromJson(data);
      } else if (response.statusCode == 400) {
        throw ArgumentError('Company already exists: ${response.body}');
      } else {
        throw Exception('Server error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create company: $e');
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

    if (response.statusCode == 200 || response.statusCode == 404 )  {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update company ${response.statusCode} ${response.body}');
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
