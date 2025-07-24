import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../theme.dart';
import '../../../../widgets/text_fields/transparent_text_field.dart';

class CompanyHeader extends StatefulWidget {
  const CompanyHeader({super.key, required this.phoneController, required this.emailController, required this.websiteController, required this.locationController, required this.descriptionController, required this.name, required this.sphere, required this.isEditing});

  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController websiteController;
  final TextEditingController locationController;
  final TextEditingController descriptionController;
  final String name;
  final String sphere;
  final ValueNotifier<bool> isEditing;

  @override
  State<CompanyHeader> createState() => _CompanyHeaderState();
}

class _CompanyHeaderState extends State<CompanyHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
      child: Column(
        children: [
          const SizedBox(height: 9),
          Text(
            widget.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.sphere,
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
                  ValueListenableBuilder<bool>(
                      valueListenable: widget.isEditing,
                      builder: (context, editing, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: editing ? [
                            _buildInfoTextField(icon: Icons.phone,
                                ctrl: widget.phoneController, keyboardType: TextInputType.phone),
                            _buildInfoTextField(icon: Icons.email, ctrl: widget.emailController),
                            _buildInfoTextField(icon: Icons.link, ctrl: widget.websiteController),
                            _buildInfoTextField(icon: Icons.location_on_outlined, ctrl: widget.locationController)
                          ] : [
                            _buildInfoRow(
                                icon: Icons.phone,
                                text: widget.phoneController.text),
                            _buildInfoRow(
                                icon: Icons.email,
                                text: widget.emailController.text,
                                isLink: true),
                            _buildInfoRow(
                                icon: Icons.link,
                                text: widget.websiteController.text,
                                isLink: true),
                            _buildInfoRow(
                                icon: Icons.location_on_outlined,
                                text: widget.locationController.text),
                          ],
                        );
                      }
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

  static Widget _buildInfoTextField({
    required IconData icon,
    required TextEditingController ctrl,
    TextInputType? keyboardType
  }) {
    if (ctrl.text == 'Не указан') ctrl.text = '';
    return Padding(padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon,
              color: Colors.white70, size: 16),
          const SizedBox(width: 8),
          SizedBox(
            width: 200,
            height: 30,
            child: TransparentTextField(
              controller: ctrl,
              keyboardType: keyboardType,
            ),
          )
        ],
      ),
    );
  }

  static Widget _buildInfoRow({
    required IconData icon,
    required String text,
    bool isLink = false,
  }) {

    Future<void> _launchURL(String url) async {
      // Добавим https:// только если ссылка не начинается с http или https
      final String formattedUrl = url.startsWith('http://') || url.startsWith('https://')
          ? url
          : 'https://$url';

      final Uri uri = Uri.parse(formattedUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $formattedUrl';
      }
    }


    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon,
              color: isLink ? AppColors.linkColor : Colors.white70, size: 16),
          const SizedBox(width: 6),
          isLink ?
              SizedBox(
                width: 150,
                child: GestureDetector(
                  onTap: () => _launchURL(text),
                  child: Text(text,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: AppColors.linkColor,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              )
              : Text(
            text,
            overflow: TextOverflow.fade,
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
