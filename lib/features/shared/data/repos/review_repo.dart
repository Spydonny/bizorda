import 'dart:convert';
import 'package:bizorda/exceptions/api_exceptions.dart';
import 'package:http/http.dart' as http;
import '../models/review.dart';

class ReviewRepository {
  final String baseUrl;
  final String? authToken;

  ReviewRepository({required this.baseUrl, this.authToken});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (authToken != null) 'Authorization': 'Bearer $authToken',
  };

  // Create review
  Future<Review> createReview({
    required String content,
    required int rating,
    required String companyId,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/reviews/'),
      headers: _headers,
      body: jsonEncode({
        'content': content,
        'rating': rating,
        'company_id': companyId,
      }),
    );

    if (res.statusCode == 200) {
      return Review.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to create review: ${res.body}');
    }
  }

  // List all reviews
  Future<List<Review>> listReviews() async {
    final res = await http.get(Uri.parse('$baseUrl/reviews/'), headers: _headers);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => Review.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  // Get review by ID
  Future<Review> getReview(String reviewId) async {
    final res = await http.get(Uri.parse('$baseUrl/reviews/$reviewId'), headers: _headers);
    if (res.statusCode == 200) {
      return Review.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Review not found');
    }
  }

  // Get reviews by user
  Future<List<Review>> listUserReviews(String userId) async {
    final res = await http.get(Uri.parse('$baseUrl/reviews/user/$userId'), headers: _headers);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => Review.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load user reviews');
    }
  }

  // Get reviews by company
  Future<List<Review>> listCompanyReviews(String companyId) async {
    final res = await http.get(Uri.parse('$baseUrl/reviews/company/$companyId'), headers: _headers);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => Review.fromJson(e)).toList();
    }
    else if(res.statusCode == 404) {
      return [];
    }
    else {
      throw Exception('Failed to load company reviews');
    }
  }

  // Update review
  Future<Review> updateReview(String reviewId, {String? content, int? rating}) async {
    final body = <String, dynamic>{};
    if (content != null) body['content'] = content;
    if (rating != null) body['rating'] = rating;

    final res = await http.put(
      Uri.parse('$baseUrl/reviews/$reviewId'),
      headers: _headers,
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      return Review.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to update review');
    }
  }

  // Delete review
  Future<void> deleteReview(String reviewId) async {
    final res = await http.delete(Uri.parse('$baseUrl/reviews/$reviewId'), headers: _headers);
    if (res.statusCode != 200) {
      throw Exception('Failed to delete review');
    }
  }
}
