import 'package:bizorda/features/shared/data/models/company.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../theme.dart';

/// A read-only variant of CompanyUpperInfoContainer, displaying company info without edit capabilities.
class CompanyHeaderReadOnly extends StatelessWidget {
  const CompanyHeaderReadOnly({
    super.key, required this.company,
  });

  final Company company;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
      child: Column(
        children: [
          const SizedBox(height: 9),
          Text(
            "${company.typeOfRegistration} ${company.name}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            company.sphere,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(icon: Icons.phone, text: company.phoneNumber ?? 'Не указан'),
                      _buildInfoRow(icon: Icons.email, text: company.email),
                      _buildInfoRow(icon: Icons.link, text: company.website ?? 'Не указан', isLink: true),
                      _buildInfoRow(icon: Icons.location_on_outlined, text: company.location ?? 'Не указан'),
                    ],
                  ),
                  const CircleAvatar(radius: 48, backgroundColor: Colors.black26),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    bool isLink = false,
  }) {
    Future<void> _launchURL(String url) async {
      final String formattedUrl = url.startsWith('http://') || url.startsWith('https://')
          ? url
          : 'https://\$url';

      final Uri uri = Uri.parse(formattedUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch \$formattedUrl';
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon,
              color: isLink ? AppColors.linkColor : Colors.white70, size: 16),
          const SizedBox(width: 6),
          isLink
              ? GestureDetector(
            onTap: () => _launchURL(text),
            child: Text(
              text,
              overflow: TextOverflow.fade,
              style: TextStyle(color: AppColors.linkColor),
              textAlign: TextAlign.start,
            ),
          )
              : Text(
            text,
            overflow: TextOverflow.fade,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
