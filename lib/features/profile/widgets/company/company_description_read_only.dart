import 'package:flutter/material.dart';
import 'package:bizorda/features/profile/widgets/company/label_local.dart';
import '../../../shared/data/models/company.dart';

/// A read-only variant of CompanyDescription, displaying description and achievements without edit controls.
class CompanyDescriptionReadOnly extends StatelessWidget {
  const CompanyDescriptionReadOnly({
    super.key,
    required this.company,
  });

  final Company company;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LabelLocal('Сведения'),
              const SizedBox(height: 8),
              Text(
                company.description?.isNotEmpty == true
                    ? company.description!
                    : 'Описание отсутствует',
                style: TextStyle(
                  color: company.description?.isNotEmpty == true
                      ? Colors.white
                      : Colors.white60,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const LabelLocal('Наши достижения'),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: const Text(
            'У нас пока нет достижений',
            style: TextStyle(color: Colors.white60),
          ),
        ),
      ],
    );
  }
}
