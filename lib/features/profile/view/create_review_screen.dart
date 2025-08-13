import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../../shared/services/review_service.dart';
import '../widgets/shared/profile_text_field.dart';
import '../widgets/shared/submit_button.dart';

class CreateReviewScreen extends StatefulWidget {
  final String companyId;

  const CreateReviewScreen({
    super.key,
    required this.companyId,
  });

  @override
  State<CreateReviewScreen> createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  late final ReviewService reviewService;
  final TextEditingController contentController = TextEditingController();
  int rating = 5; // default rating

  @override
  void initState() {
    reviewService = GetIt.I<ReviewService>();
    super.initState();
  }

  void createReview(BuildContext context) async {
    final content = contentController.text.trim();

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, введите отзыв')),
      );
      return;
    }

    try {
      await reviewService.createReview(
        content: content,
        rating: rating,
        companyId: widget.companyId,
      );

      if (!context.mounted) return;
      context.pop(); // back to previous screen
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при отправке: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black26,
                    child: Icon(Icons.person, color: Colors.white54),
                  ),
                  const SizedBox(width: 12),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 22),
                      children: [
                        TextSpan(
                          text: 'Оставить ',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text: 'отзыв',
                          style: TextStyle(
                              color: Colors.white38, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Review text field
              ProfileTextField(
                controller: contentController,
                hintText: 'Ваш отзыв...',
              ),
              const SizedBox(height: 12),

              // Rating selector
              Row(
                children: [
                  const Text(
                    "Оценка:",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: List.generate(5, (index) {
                      final starIndex = index + 1;
                      return IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          setState(() {
                            rating = starIndex;
                          });
                        },
                        icon: Icon(
                          starIndex <= rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.blueAccent,
                          size: 28,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Submit button
              Row(
                children: [
                  Expanded(
                    child: SubmitButton(
                      onPressed: () => createReview(context),
                      text: "Отправить",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
