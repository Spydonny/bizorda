import 'package:flutter/material.dart';

import '../../../theme.dart';
import '../../../widgets/navigation_widgets/navigation_button.dart';

class CompanyProfileAppBar extends StatelessWidget {
  final bool isEditing;
  final String companyName;
  final String companyDescription;
  final String phone;
  final String email;
  final String website;
  final String location;
  final VoidCallback? onEdit;
  final VoidCallback? onCancel;

  const CompanyProfileAppBar({
    super.key,
    required this.isEditing,
    required this.companyName,
    required this.companyDescription,
    required this.phone,
    required this.email,
    required this.website,
    required this.location,
    this.onEdit, this.onCancel
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBar,
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Column(
          children: [
            Row(
              children: [
                const NavigationButton(chosenIdx: 1),
                const Spacer(),
                isEditing ? IconButton(onPressed: onCancel, icon: const Icon(Icons.cancel_outlined))
                    : IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
              ],
            ),
            const SizedBox(height: 9),
            Text(
              companyName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              companyDescription,
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
                        _buildInfoRow(icon: Icons.phone, text: phone),
                        _buildInfoRow(icon: Icons.email, text: email, isLink: true),
                        _buildInfoRow(icon: Icons.link, text: website, isLink: true),
                        _buildInfoRow(icon: Icons.location_on_outlined, text: location,),
                      ],
                    ),
                    const CircleAvatar(radius: 48, backgroundColor: Colors.black26),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildInfoRow({
    required IconData icon,
    required String text,
    bool isLink = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: isLink ? AppColors.linkColor : Colors.white70, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: isLink ? AppColors.linkColor : Colors.white,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
