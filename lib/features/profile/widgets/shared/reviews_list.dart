import 'package:bizorda/features/profile/view/create_review_screen.dart';
import 'package:flutter/material.dart';
import '../../../../service_locator.dart';
import '../../../../theme.dart';
import '../../../shared/data/models/review.dart';
import '../../../shared/services/review_service.dart';


class ReviewsList extends StatelessWidget {
  final String companyId;
  final bool isThemSelf;

  const ReviewsList({
    super.key,
    required this.companyId, this.isThemSelf = true,

  });

  @override
  Widget build(BuildContext context) {
    final reviewService = getIt<ReviewService>();

    return FutureBuilder<List<Review>>(
      future: reviewService.getCompanyReviews(companyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Ошибка: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final reviews = snapshot.data ?? [];

        if (reviews.isEmpty) {
          return const Center(
            child: Text(
              'Отзывов пока нет',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Отзывы',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.white),
                ),
                isThemSelf ? SizedBox()
                : IconButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CreateReviewScreen(companyId: companyId))
                    ),
                    icon: Icon(Icons.add))
              ],
            ),
            const SizedBox(height: 12),
            ...reviews.map((review) => _ReviewCard(review: review)),
          ],
        );
      },
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(backgroundColor: Colors.grey),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review.reviewerName,
                      style: const TextStyle(color: Colors.white)),
                  Text(
                    _formatDate(review.timestamp),
                    style: const TextStyle(
                        color: Colors.white38, fontSize: 10),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.blueAccent,
                    size: 18,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.content,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }
}
