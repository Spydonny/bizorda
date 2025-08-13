import 'package:flutter/material.dart';

class DocsTab extends StatelessWidget {
  const DocsTab({super.key, required this.cards});
  final List<FinancialReportCard> cards;


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Медиа и подтверждения', style: Theme.of(context).textTheme.titleMedium,),
            SizedBox(height: 12,),
            Text('Документы и отчеты'),
            SizedBox(height: 4),
            ...cards
          ],
        ),
    );
  }
}

class FinancialReportCard extends StatelessWidget {
  const FinancialReportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 28),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Финансовый отчет Q4 2023',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'PDF',
                      style: TextStyle(color: Colors.blue),
                    ),
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Источник: ',
                            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                          TextSpan(
                            text: 'Аудиторская компания PwC, 15.01.2024, Отчет №2024-001',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Кнопка скачать
              OutlinedButton.icon(
                onPressed: () {
                  // Здесь можно реализовать скачивание
                },
                icon: const Icon(Icons.download),
                label: const Text('Скачать'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

