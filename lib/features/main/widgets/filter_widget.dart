import 'package:flutter/material.dart';

import '../main_page.dart';


class FilterDialog extends StatefulWidget {
  final FilterCriteria initialCriteria;

  const FilterDialog({ super.key, required this.initialCriteria });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final List<String> regTypes = ['ООО', 'ИП', 'ТОО', 'ФизЛицо'];
  final List<String> statuses = ['Свободен', 'В процессе сделки'];
  final List<String> orgTypes = ['Стартап', 'Подрядчик', 'Исполнитель', 'Инвестор'];
  final List<String> okeds = ['Торговля', 'Производство', 'IT', 'Образование'];

  late String? _regType;
  late String? _status;
  late String? _orgType;
  late String? _oked;
  late double _rating;
  late TextEditingController _nameCtrl;
  late TextEditingController _chefCtrl;

  @override
  void initState() {
    super.initState();
    final c = widget.initialCriteria;
    _regType = c.regType;
    _status = c.status;
    _orgType = c.orgType;
    _oked = c.oked;
    _rating = c.minRating;
    _nameCtrl = TextEditingController(text: c.nameQuery);
    _chefCtrl = TextEditingController(text: c.chefQuery);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width * 0.35;
    return Dialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Заголовок и крестик
              Row(
                children: [
                  const Spacer(),
                  const Text('Ф И Л Ь Т Р', style: TextStyle(color: Colors.white, fontSize: 22)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2 ряда дропдаунов
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDropdown('Тип регистрации', _regType, regTypes, w,
                          (v) => setState(() => _regType = v, )),
                  _buildDropdown('Статус', _status, statuses, w,
                          (v) => setState(() => _status = v)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDropdown('Тип орг.', _orgType, orgTypes, w,
                          (v) => setState(() => _orgType = v)),
                  _buildDropdown('ОКЭД', _oked, okeds, w,
                          (v) => setState(() => _oked = v)),
                ],
              ),
              const SizedBox(height: 16),

              // Текстовые поля
              _buildTextField('Название компании', 'Введите название', _nameCtrl),
              const SizedBox(height: 16),
              _buildTextField('Имя директора', 'Введите имя', _chefCtrl),
              const SizedBox(height: 24),

              // Слайдер рейтинга
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Рейтинг (мин.)', style: TextStyle(color: Colors.white)),
                  Text(_rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white)),
                ],
              ),
              Slider(
                value: _rating,
                onChanged: (v) => setState(() => _rating = v),
                min: 0,
                max: 5,
                divisions: 50,
                activeColor: Colors.blue,
                inactiveColor: Colors.white54,
              ),
              const SizedBox(height: 20),

              // Кнопки
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F0F0F),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.pop(context, FilterCriteria.empty);
                      },
                      child: const Text('Сбросить', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                          FilterCriteria(
                            regType: _regType,
                            status: _status,
                            orgType: _orgType,
                            oked: _oked,
                            minRating: _rating,
                            nameQuery: _nameCtrl.text.trim(),
                            chefQuery: _chefCtrl.text.trim(),
                          ),
                        );
                      },
                      child: const Text('Применить', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String label,
      String? value,
      List<String> items,
      double width,
      ValueChanged<String?> onChanged,
      ) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: value,
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
            dropdownColor: Colors.black,
            decoration: InputDecoration(
              hintText: 'Выберите',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.black,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 14),
            ),
            style: const TextStyle(color: Colors.white),
          ),

        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.black,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }
}
