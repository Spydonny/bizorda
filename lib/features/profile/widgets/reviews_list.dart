import 'package:flutter/material.dart';
import '../../../theme.dart';

class ReviewsList extends StatelessWidget {
  const ReviewsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ⬇️ Headline
        Text(
          'Отзывы',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 12),
        // ⬇️ Your review cards
        _ReviewCard(),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                children: const [
                  Text('Айдар Сериков',
                      style: TextStyle(color: Colors.white)),
                  Text('ТОО "ФинансГрупп"',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text('20.04.2023',
                      style: TextStyle(color: Colors.white38, fontSize: 10)),
                ],
              ),
              const Spacer(),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < 4 ? Icons.star : Icons.star_border,
                    color: Colors.blueAccent,
                    size: 18,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Отличная компания! Разработали для нас мобильное приложение в срок и с высоким качеством. Команда профессионалов, которые знают свое дело. Рекомендую!',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
