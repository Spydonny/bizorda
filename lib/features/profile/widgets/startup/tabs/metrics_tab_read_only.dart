import 'package:flutter/material.dart';

import '../../../../shared/data/models/company.dart';

class MetricsTabReadOnly extends StatelessWidget {
  final Company company;

  const MetricsTabReadOnly({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _metricRow('Выручка (12 мес)', company.totalRevenue, usd: true),
          _metricRow('Клиенты', company.clients),
          _metricRow('Средний чек', company.midReceipt, usd: true),
          _metricRow('CAC', company.CAC, usd: true, negative: false),
          _metricRow('LTV', company.LTV, usd: true),
          _metricRow('Операц. прибыль', company.income, usd: true, negative: true),
        ],
      ),
    );
  }

  Widget _metricRow(String label, num? value,
      {bool usd = false, bool negative = false}) {
    value = value ?? 0;
    final isNegative = value < 0;
    final color = isNegative
        ? Colors.red
        : negative
        ? Colors.green
        : Colors.white;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            '${usd ? '\$' : ''}${(value).toStringAsFixed(usd ? 0 : 2)} ${usd ? 'USD' : ''}',
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
