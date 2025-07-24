import 'package:bizorda/features/profile/widgets/company/label_local.dart';
import 'package:bizorda/widgets/text_fields/transparent_text_field.dart';
import 'package:flutter/material.dart';

import '../../../shared/data/models/company.dart';

class CompanyDescription extends StatelessWidget {
  final Company company;
  final ValueNotifier<bool> isEditing;
  final TextEditingController controller;

  const CompanyDescription({super.key, required this.company, required this.isEditing, required this.controller});

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
          child: ValueListenableBuilder<bool>(
            valueListenable: isEditing,
            builder: (context, editing, _) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LabelLocal('Сведения'),
                    const SizedBox(height: 8),
                    editing
                        ? TransparentTextField(
                      controller: controller,
                      minLines: 8,
                      maxLines: 16,
                      textInputAction: TextInputAction.newline,
                      contentPadding: EdgeInsets.symmetric(vertical: 64),
                    )
                        : _buildDescription(controller)

                  ],
              );
            },
          )
        ),
        const SizedBox(height: 20),
        const LabelLocal('Наши достижения'),
        const Text('        У нас пока нет достижений'),
      ],
    );
  }

  Widget _buildDescription(TextEditingController controller) {
    if (controller.text.isNotEmpty) {
      return Text(
        controller.text,
        style: const TextStyle(color: Colors.white, height: 1.4),
      );
    } else {
      return Text(
        'Описание отсутствует',
        style: TextStyle(color: Colors.white60),
      );
    }
  }
}
