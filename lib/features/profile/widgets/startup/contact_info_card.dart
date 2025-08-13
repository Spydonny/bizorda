import 'package:bizorda/features/profile/widgets/startup/button_local.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact_info_container.dart';

class ContactInfoCard extends StatefulWidget {
  const ContactInfoCard({
    super.key,
    required this.isEditing,
    required this.phoneController,
    required this.emailController,
    required this.websiteController,
    required this.locationController,
    required this.ratingController,
    required this.statusController,
    required this.teamController,
    required this.fundingController, required this.companyName, required this.username,
  });

  final ValueNotifier<bool> isEditing;

  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController websiteController;
  final TextEditingController locationController;

  final TextEditingController ratingController;
  final TextEditingController statusController;
  final TextEditingController teamController;
  final TextEditingController fundingController;

  final String companyName;
  final String username;

  @override
  State<ContactInfoCard> createState() => _ContactInfoCardState();
}

class _ContactInfoCardState extends State<ContactInfoCard> {
  @override
  Widget build(BuildContext context) {
    return ContactInfoContainer(
        leftChild: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoField(
          icon: Icons.phone,
          controller: widget.phoneController,
          isLink: false,
          keyboardType: TextInputType.phone,
        ),
        _buildInfoField(
          icon: Icons.email,
          controller: widget.emailController,
          isLink: true,
        ),
        _buildInfoField(
          icon: Icons.language,
          controller: widget.websiteController,
          isLink: true,
        ),
        _buildInfoField(
          icon: Icons.location_on,
          controller: widget.locationController,
        ),
      ],
    ),
        rating: widget.ratingController.text, status: widget.statusController.text,
        team: widget.teamController.text, funding: '${widget.fundingController.text} USD',
        bottomWidget: ButtonLocal(label: 'Отправить модерацию', iconData: Icons.insert_drive_file,
        onPressed: () {
          sendEmail(widget.username, widget.companyName);
        },),
    );
  }

  Widget _buildInfoField({
    required IconData icon,
    required TextEditingController controller,
    bool isLink = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: widget.isEditing,
              builder: (_, editing, __) {
                if (editing) {
                  return TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    style: const TextStyle(color: Colors.white, fontSize: 10), // Было по умолчанию (14)
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      filled: true,
                      fillColor: Color(0xFF222222),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: isLink ? () => _launchUrl(controller.text) : null,
                    child: Text(
                      controller.text,
                      style: TextStyle(
                        fontSize: 12, // Было 14
                        color: isLink ? Colors.blue : Colors.white70,
                        decoration: isLink ? TextDecoration.underline : TextDecoration.none,
                      ),
                    ),
                  );
                }
              },
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

  Future<void> sendEmail(String username, String companyName) async {
    final smtpServer = gmail('omralitamer64@gmail.com', 'xmpk rwml duvl yrfa'); // App password, НЕ обычный пароль!

    final message = Message()
      ..from = Address('omralitamer64@gmail.com', 'Tamerlan')
      ..recipients.add('bazarkatzandos@gmail.com')
      ..subject = 'Запрос от $username'
      ..text = '$companyName хочет податся на финансирование';

    try {
      final sendReport = await send(message, smtpServer);
      print('Письмо отправлено: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Ошибка: $e');
      for (var p in e.problems) {
        print('Проблема: ${p.code}: ${p.msg}');
      }
    }
  }

}
