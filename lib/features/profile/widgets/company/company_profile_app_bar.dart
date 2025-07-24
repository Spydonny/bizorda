import 'package:bizorda/widgets/text_fields/transparent_text_field.dart';
import 'package:flutter/material.dart';

import '../../../../theme.dart';
import '../../../../widgets/navigation_widgets/navigation_button.dart';

class CompanyProfileAppBar extends StatefulWidget {
  final ValueNotifier<bool> isEditing;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController websiteController;
  final TextEditingController locationController;
  final TextEditingController descriptionController;
  final String sphere;
  final VoidCallback? onSave;

  const CompanyProfileAppBar({
    super.key,
    required this.isEditing,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.websiteController,
    required this.locationController,
    this.onSave, required this.sphere, required this.descriptionController,
  });

  @override
  State<CompanyProfileAppBar> createState() => _CompanyProfileAppBarState();
}

class _CompanyProfileAppBarState extends State<CompanyProfileAppBar> {
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
                widget.isEditing.value
                    ? Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        widget.onSave;
                        setState(() {
                          String orDefault(String? value, String defaultValue) =>
                              (value != null && value.trim().isNotEmpty) ? value : defaultValue;
                          widget.phoneController.text = orDefault(widget.phoneController.text, 'Не указан');
                          widget.websiteController.text = orDefault(widget.websiteController.text, 'Не указан');
                          widget.locationController.text = orDefault(widget.locationController.text, 'Не указан');
                          widget.descriptionController.text = orDefault(widget.descriptionController.text, 'Описание отсутствует');

                          widget.isEditing.value = false;
                        });
                      },
                      icon: const Icon(Icons.save),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          String orDefault(String? value, String defaultValue) =>
                              (value != null && value.trim().isNotEmpty) ? value : defaultValue;
                          widget.phoneController.text = orDefault(widget.phoneController.text, 'Не указан');
                          widget.websiteController.text = orDefault(widget.websiteController.text, 'Не указан');
                          widget.locationController.text = orDefault(widget.locationController.text, 'Не указан');
                          widget.descriptionController.text = orDefault(widget.descriptionController.text, 'Описание отсутствует');

                          widget.isEditing.value = false;
                        });
                      },
                      icon: const Icon(Icons.cancel_outlined),
                    )
                  ],
                )
                    : IconButton(
                  onPressed: () {
                    setState(() {
                      widget.isEditing.value = true;
                    });
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            const SizedBox(height: 9),
            Text(
              widget.nameController.text,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.isEditing.value ? [
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon,
              color: isLink ? AppColors.linkColor : Colors.white70, size: 16),
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

