import 'package:flutter/material.dart';

import '../../../../shared/data/models/company.dart';

class InvestmentTabReadOnly extends StatelessWidget {
  final Company company;

  const InvestmentTabReadOnly({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _metricRow('Уже привлечено', company.investmentOffered, usd: true),
          _metricRow('Требуется', company.investmentRequired, usd: true),
          _textRow('Раунд инвестиций', company.investmentRound),
          _textRow('Готовность отдать долю', '${(company.investmentOffered ?? 0)/(company.investmentRequired ?? 1)}%'),
          _textRow('Бизнес-модель', company.businessModel),
        ],
      ),
    );
  }

  Widget _metricRow(String label, num? value, {bool usd = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            '${usd ? '\$' : ''}${(value ?? 0).toStringAsFixed(usd ? 0 : 2)} ${usd ? 'USD' : ''}',
            style: const TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _textRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value ?? 'Не указан', style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
