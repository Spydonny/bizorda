import 'package:bizorda/features/profile/widgets/label_local.dart';
import 'package:flutter/material.dart';

import '../../shared/data/models/company.dart';

class CompanyInfo extends StatelessWidget {
  final Company company;

  const CompanyInfo({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme
                .of(context)
                .colorScheme
                .onSecondaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LabelLocal('Сведения'),
              const SizedBox(height: 8),
              if (company.description != null &&
                  company.description!.isNotEmpty)
                Text(
                  company.description!,
                  style: const TextStyle(color: Colors.white, height: 1.4),
                )
              else
                const Text(
                  'Описание отсутствует',
                  style: TextStyle(color: Colors.white60),
                ),

            ],
          ),
        ),
        const SizedBox(height: 20),
        const LabelLocal('Наши достижения'),
        const Text('        У нас пока нет достижений'),
      ],
    );
  }
}