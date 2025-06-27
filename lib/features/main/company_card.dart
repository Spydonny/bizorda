import 'package:flutter/material.dart';

import '../shared/data/models/company.dart';

class CompanyCard extends StatelessWidget {
  final Company company;

  const CompanyCard({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Логотип
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade800,
            backgroundImage:
            company.logo != null ? NetworkImage(company.logo!) : null,
            child: company.logo == null
                ? const Icon(Icons.business, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 8),

          // Название компании
          Text(
            company.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          Row(
            children: const [
              Icon(Icons.star, color: Colors.amber, size: 16),
              SizedBox(width: 4),
              Text("4.6", style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),

          const SizedBox(height: 4),

          // Сфера деятельности
          Text(
            'Сфера: ${company.sphere}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Email
          Text(
            company.email,
            style: const TextStyle(fontSize: 12, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // ОКЭД
          Text(
            'ОКЭД: ${company.OKED}',
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),

          // Описание
          if (company.description != null && company.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                company.description!,
                style: const TextStyle(fontSize: 12, color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // Сайт
          if (company.website != null && company.website!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                company.website!,
                style: const TextStyle(fontSize: 12, color: Colors.blueAccent),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // Адрес
          if (company.location != null && company.location!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                company.location!,
                style: const TextStyle(fontSize: 12, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // Телефон
          if (company.phoneNumber != null && company.phoneNumber!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                company.phoneNumber!,
                style: const TextStyle(fontSize: 12, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
