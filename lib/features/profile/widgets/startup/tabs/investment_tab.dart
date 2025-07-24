import 'package:flutter/material.dart';

import '../../../../../widgets/text_fields/transparent_text_field.dart';

class InvestmentTabEditable extends StatelessWidget {
  final ValueNotifier<bool> isEditing;

  final TextEditingController offeredController;
  final TextEditingController requiredController;
  final TextEditingController roundController;
  final TextEditingController shareController;
  final TextEditingController modelController;

  const InvestmentTabEditable({
    super.key,
    required this.isEditing,
    required this.offeredController,
    required this.requiredController,
    required this.roundController,
    required this.shareController,
    required this.modelController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldRow('Уже привлечено', offeredController, suffix: 'USD'),
          _buildFieldRow('Требуется', requiredController, suffix: 'USD'),
          _buildFieldRow('Раунд инвестиций', roundController),
          _buildFieldRow('Готовность отдать долю (%)', shareController, suffix: '%'),
          _buildFieldRow('Бизнес-модель', modelController),
        ],
      ),
    );
  }

  Widget _buildFieldRow(
      String label,
      TextEditingController controller, {
        String? suffix,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: ValueListenableBuilder<bool>(
              valueListenable: isEditing,
              builder: (_, editing, __) {
                if (editing) {
                  return SizedBox(
                    height: 35,
                    child: TransparentTextField(
                      controller: controller,
                      textAlign: TextAlign.right,
                      suffixText: suffix,
                      fontSize: 12,
                    ),
                  );
                } else {
                  final text = controller.text.trim();
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      suffix != null && text.isNotEmpty ? '$text $suffix' : text,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
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
}
