import 'dart:math';
import 'package:bizorda/features/main/widgets/company_card.dart';
import 'package:flutter/material.dart';
import 'package:bizorda/features/main/widgets/filter_widget.dart';
import 'package:bizorda/token_notifier.dart';
import '../../widgets/navigation_widgets/navigation_button.dart';
import '../shared/data/models/company.dart';
import '../shared/data/models/user.dart';
import '../shared/data/repos/company_repo.dart';
import '../shared/data/repos/user_repo.dart';

/// Класс-результат диалога фильтрации
class FilterCriteria {
  final String? regType;
  final String? status;
  final String? orgType;
  final String? oked;
  final double minRating;
  final String nameQuery;
  final String chefQuery;

  const FilterCriteria({
    this.regType,
    this.status,
    this.orgType,
    this.oked,
    this.minRating = 0.0,
    this.nameQuery = '',
    this.chefQuery = '',
  });

  /// Возвращает "пустой" набор фильтров (для сброса)
  static const empty = FilterCriteria();
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final CompanyRepository _companyRepo = CompanyRepository();
  final UsersRepo _usersRepo = UsersRepo(token: tokenNotifier.value);

  late TabController _tabController;

  List<_CompanyWithUser> _allItems = [];
  List<_CompanyWithUser> _filteredItems = [];

  /// Текущие критерии
  FilterCriteria _criteria = FilterCriteria.empty;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final rawCompanies = await _companyRepo.listCompanies();
    final companies =
    rawCompanies.map((json) => Company.fromJson(json)).toList();
    final users = await _usersRepo.getUsers();

    final list = companies.map((c) {
      final user =
      users.firstWhere((u) => u.companyId == c.id);
      // Для примера рейтинг рандомный
      return _CompanyWithUser(
        company: c,
        userFullName: user.fullname ?? '',
        rating: Random().nextInt(3) + 2.0,
      );
    }).toList();

    setState(() {
      _allItems = list;
      _applyFilters();
    });
  }

  /// Применяем фильтры из _criteria к _allItems
  void _applyFilters() {
    setState(() {
      _filteredItems = _allItems.where((item) {
        final c = item.company;

        if (_criteria.regType != null && c.typeOrg != _criteria.regType) {
          return false;
        }
        if (_criteria.status != null && 'Свободен' != _criteria.status) {
          return false;
        }
        if (_criteria.orgType != null && c.typeOrg != _criteria.orgType) {
          return false;
        }
        if (_criteria.oked != null && (c.OKED != _criteria.oked && c.sphere != _criteria.oked)) {
          return false;
        }
        if (item.rating < _criteria.minRating) {
          return false;
        }
        if (_criteria.nameQuery.isNotEmpty &&
            !c.name.toLowerCase().contains(_criteria.nameQuery.toLowerCase())) {
          return false;
        }
        if (_criteria.chefQuery.isNotEmpty &&
            !item.userFullName
                .toLowerCase()
                .contains(_criteria.chefQuery.toLowerCase())) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  /// Открываем диалог и ждём нового набора фильтров
  Future<void> _openFilterDialog() async {
    final result = await showDialog<FilterCriteria>(
      context: context,
      builder: (_) => FilterDialog(
        initialCriteria: _criteria,
      ),
    );

    if (result != null) {
      setState(() {
        _criteria = result;
        _applyFilters();
      });
    }
  }

  Widget _buildGrid(List<_CompanyWithUser> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.95,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return CompanyCard(
          company: item.company,
          CEO: item.userFullName,
          rating: item.rating,
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final businesses = _filteredItems
        .where((e) => e.company.typeOrg != 'Инвестор')
        .toList();
    final investors = _filteredItems
        .where((e) => e.company.typeOrg == 'Инвестор')
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: NavigationButton(chosenIdx: 0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Компании'),
            IconButton(
              onPressed: _openFilterDialog,
              icon: const Icon(Icons.filter_alt_outlined),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Бизнесы'), Tab(text: 'Инвесторы')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGrid(businesses),
          _buildGrid(investors),
        ],
      ),
    );
  }
}

class _CompanyWithUser {
  final Company company;
  final double rating;
  final String userFullName;

  _CompanyWithUser({
    required this.company,
    required this.userFullName,
    required this.rating,
  });
}
