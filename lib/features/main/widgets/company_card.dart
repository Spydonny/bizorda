import 'package:bizorda/features/profile/view/others_startup_profile_page.dart';
import 'package:flutter/material.dart';

import '../../profile/view/others_company_profile_page.dart';
import '../../shared/data/models/company.dart';

class CompanyCard extends StatelessWidget {
  final Company company;
  final String CEO;
  final double rating;

  const CompanyCard({super.key, required this.company, required this.CEO, required this.rating});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => company.typeOrg == 'Стартап'
              ? OthersStartupProfilePage(companyID: company.id)
              : OthersCompanyProfilePage(companyId: company.id))
      ),
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Аватар
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey.shade800,
                    backgroundImage: company.logo != null
                        ? NetworkImage(
                        "https://enterra-api.onrender.com${company.logo!}")
                        : null,
                    child: company.logo == null
                        ? const Icon(
                        Icons.business, color: Colors.white, size: 32)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Название
                        Text(
                          company.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Тип регистрации и сфера
                        Text(
                          "${company.typeOfRegistration} • ${company.sphere}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),

                        RatingStars(rating: rating),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                ],
              ),
              Text("Тип: ${company.typeOrg}"),
              // Руководитель
              Text(
                "Руководитель: $CEO",
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),

              const SizedBox(height: 8),

              // Статус "свободен"
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Свободен",
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ],
          )
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  final double rating;
  final double iconSize;
  final Color color;
  final TextStyle? textStyle;

  const RatingStars({
    super.key,
    required this.rating,
    this.iconSize = 14,
    this.color = Colors.amber,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.25 && (rating - fullStars) < 0.75;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < fullStars; i++)
          Icon(Icons.star, color: color, size: iconSize),
        if (hasHalfStar)
          Icon(Icons.star_half, color: color, size: iconSize),
        for (int i = 0; i < emptyStars; i++)
          Icon(Icons.star_border, color: color, size: iconSize),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: textStyle ?? TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}

