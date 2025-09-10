import 'package:bizorda/features/profile/widgets/startup/contact_info_container.dart';
import 'package:bizorda/features/shared/data/models/company.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfoCardReadOnly extends StatelessWidget {
  const ContactInfoCardReadOnly({super.key, required this.company});
  final Company company;

  @override
  Widget build(BuildContext context) {
    return ContactInfoContainer(
        leftChild: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoField(
              icon: Icons.phone,
              isLink: false,
              value: company.phoneNumber,
            ),
            _buildInfoField(
              icon: Icons.email,
              value: company.email,
            ),
            _buildInfoField(
              icon: Icons.language,
              isLink: true,
              value: company.website,
            ),
            _buildInfoField(
              icon: Icons.location_on,
              value: company.location,
            ),
          ],
        ),
        rating: '4.5', status: 'Публичный', team: '1', funding: company.investmentOffered.toString());
  }

  Widget _buildInfoField({
    required IconData icon,
    required String? value,
    bool isLink = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: isLink ? () => _launchUrl(value??'') : null,
              child: Text(
                value ?? 'Не указан',
                style: TextStyle(
                  fontSize: 12,
                  color: isLink ? Colors.blue : Colors.white70,
                  decoration: isLink ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _launchUrl(String url) async {
    final formatted = url.startsWith('http') ? url : 'https://$url';
    final uri = Uri.parse(formatted);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
