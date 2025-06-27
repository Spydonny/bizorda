import 'package:flutter/material.dart';

import '../../widgets/navigation_widgets/navigation_button.dart';
import '../shared/data/models/company.dart';
import '../shared/data/repos/company_repo.dart';
import 'company_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final CompanyRepository _repo = CompanyRepository();
  late Future<List<Company>> _futureCompanies;

  @override
  void initState() {
    super.initState();
    _futureCompanies = _loadCompanies();
  }

  Future<List<Company>> _loadCompanies() async {
    final rawList = await _repo.listCompanies();
    return rawList.map((json) => Company.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: NavigationButton(chosenIdx: 0),
        title: const Text("Компании")
      ),
      body: FutureBuilder<List<Company>>(
        future: _futureCompanies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Компании не найдены'));
          }

          final companies = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.95,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: companies.length,
            itemBuilder: (context, index) {
              return CompanyCard(company: companies[index]);
            },
          );
        },
      ),
    );
  }
}
