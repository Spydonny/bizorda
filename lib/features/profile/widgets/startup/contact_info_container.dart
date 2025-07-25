import 'package:flutter/material.dart';

class ContactInfoContainer extends StatelessWidget {
  final Widget leftChild;

  final String rating;
  final String status;
  final String team;
  final String funding;
  final Widget? bottomWidget;

  const ContactInfoContainer({
    super.key,
    required this.leftChild,
    required this.rating,
    required this.status,
    required this.team,
    required this.funding, this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'Контактная информация',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 1, child: leftChild),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: 1,
                height: 130,
                color: Colors.grey[700],
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildStatField('Рейтинг', rating),
                    buildStatField('Статус', status),
                    buildStatField('Команда', team),
                    buildStatField('Финансирование', funding, Colors.green),
                  ],
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 16),
            child: bottomWidget ?? SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget buildStatField(String label, String value, [Color color = Colors.white]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Text(value, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}
