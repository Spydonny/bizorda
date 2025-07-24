import 'package:flutter/material.dart';

import '../../../../../widgets/text_fields/transparent_text_field.dart';

class MetricsTabEditable extends StatelessWidget {
  final ValueNotifier<bool> isEditing;

  final TextEditingController revenueController;
  final TextEditingController clientsController;
  final TextEditingController receiptController;
  final TextEditingController cacController;
  final TextEditingController ltvController;
  final TextEditingController incomeController;

  const MetricsTabEditable({
    super.key,
    required this.isEditing,
    required this.revenueController,
    required this.clientsController,
    required this.receiptController,
    required this.cacController,
    required this.ltvController,
    required this.incomeController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldRow('Выручка (12 мес)', revenueController, suffix: 'USD'),
          _buildFieldRow('Клиенты', clientsController),
          _buildFieldRow('Средний чек', receiptController, suffix: 'USD'),
          _buildFieldRow('CAC', cacController, suffix: 'USD'),
          _buildFieldRow('LTV', ltvController, suffix: 'USD'),
          _buildFieldRow('Операц. прибыль', incomeController, suffix: 'USD'),
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
            child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
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
                      )
                  );
                } else {
                  final text = controller.text.trim();
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      suffix != null && text.isNotEmpty ? '$text $suffix' : text,
                      style: TextStyle(
                        color: _getColor(text),
                        fontSize: 12,
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

  Color _getColor(String text) {
    final value = num.tryParse(text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
    return value < 0 ? Colors.red : Colors.green;
  }
}
