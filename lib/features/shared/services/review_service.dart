import 'package:flutter/material.dart';

import '../data/models/review.dart';
import '../data/repos/review_repo.dart';

class ReviewService {
  final ReviewRepository _repository;

  ReviewService(this._repository);

  Future<List<Review>> getAllReviews() async {
    return await _repository.listReviews();
  }

  Future<List<Review>> getCompanyReviews(String companyId) async {
    return await _repository.listCompanyReviews(companyId);
  }

  Future<List<Review>> getUserReviews(String userId) async {
    return await _repository.listUserReviews(userId);
  }

  Future<Review> createReview({
    required String content,
    required int rating,
    required String companyId,
  }) async {
    return await _repository.createReview(
      content: content,
      rating: rating,
      companyId: companyId,
    );
  }

  Future<Review> updateReview({
    required String reviewId,
    String? content,
    int? rating,
  }) async {
    return await _repository.updateReview(
      reviewId,
      content: content,
      rating: rating,
    );
  }

  Future<void> deleteReview(String reviewId) async {
    await _repository.deleteReview(reviewId);
  }
}
