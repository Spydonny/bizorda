import 'package:bizorda/features/profile/widgets/shared/posts_list.dart';
import 'package:bizorda/features/profile/widgets/startup/tabs/team_tab.dart';
import 'package:bizorda/features/profile/widgets/startup/widgets.dart';
import 'package:bizorda/token_notifier.dart';
import 'package:bizorda/widgets/navigation_widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talker/talker.dart';

import '../../../widgets/loading/loading_widget.dart';
import '../../feed/data/models/post.dart';
import '../../shared/data/models/company.dart';
import '../../shared/data/models/user.dart';
import '../../shared/data/repos/user_repo.dart';
import '../logic/bloc/company_profile_bloc.dart';


class StartupProfilePage extends StatefulWidget {
  const StartupProfilePage({super.key, required this.user, required this.token});
  final User user;
  final String token;

  @override
  State<StartupProfilePage> createState() => _StartupProfilePageState();
}

class _StartupProfilePageState extends State<StartupProfilePage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ValueNotifier<bool> isEditing = ValueNotifier<bool>(false);
  final List<User> _teamMembers = [];
  final List<Widget> cards = [];
  bool _isLoadingTeam = true;

  late final Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _initControllers();

    context.read<CompanyProfileBloc>().add(
      LoadCompanyProfile(widget.user.companyId, widget.token),
    );

    _loadTeamMembers(widget.user.companyId);
  }

  void _initControllers() {
    _controllers = {
      'name': TextEditingController(),
      'sphere': TextEditingController(),
      'phone': TextEditingController(),
      'email': TextEditingController(),
      'website': TextEditingController(),
      'location': TextEditingController(),
      'description': TextEditingController(),
      'offered': TextEditingController(),
      'required': TextEditingController(),
      'round': TextEditingController(),
      'share': TextEditingController(),
      'model': TextEditingController(),
      'revenue': TextEditingController(),
      'clients': TextEditingController(),
      'receipt': TextEditingController(),
      'cac': TextEditingController(),
      'ltv': TextEditingController(),
      'income': TextEditingController(),
    };
  }

  @override
  void dispose() {
    isEditing.dispose();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    context.read<CompanyProfileBloc>().add(ResetCompanyProfile());
    super.dispose();
  }

  Future<void> _loadTeamMembers(String companyId) async {
    final _repo = UsersRepo(token: tokenNotifier.value);
    try {
      final users = await _repo.getUserByCompanyId(companyId);
      setState(() {
        _teamMembers.clear();
        _teamMembers.addAll(users);
        cards.clear();
        cards.addAll(_teamMembers.map((u) => UserCard(user: u)));
        _isLoadingTeam = false;
      });
    } catch (e, stack) {
      Talker().handle(e, stack, 'Ошибка при загрузке команды');
      setState(() => _isLoadingTeam = false);
    }
  }

  void _fillControllers(Company c) {
    void set(String key, String value) {
      final controller = _controllers[key];
      if (controller != null && controller.text != value) {
        controller.text = value;
      }
    }

    set('name', "${c.typeOfRegistration} ${c.name}");
    set('sphere', c.sphere);
    set('phone', c.phoneNumber ?? 'Не указан');
    set('email', c.email);
    set('website', c.website ?? 'Не указан');
    set('location', c.location ?? 'Не указан');
    set('description', c.description ?? 'Описание отсутствует');
    set('offered', c.investmentOffered?.toStringAsFixed(0) ?? '0');
    set('required', c.investmentRequired?.toStringAsFixed(0) ?? '0');
    set('round', c.investmentRound ?? 'Не указан');
    set('share', ((c.investmentOffered ?? 0) / (c.investmentRequired ?? 1)).toStringAsFixed(0));
    set('model', c.businessModel ?? 'Не указан');
    set('revenue', c.totalRevenue?.toStringAsFixed(0) ?? '0');
    set('clients', c.clients?.toString() ?? '0');
    set('receipt', c.midReceipt?.toStringAsFixed(0) ?? '0');
    set('cac', c.CAC?.toStringAsFixed(0) ?? '0');
    set('ltv', c.LTV?.toStringAsFixed(0) ?? '0');
    set('income', c.income?.toStringAsFixed(0) ?? '0');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CompanyProfileBloc, CompanyProfileState>(
      listener: (context, state) {
        if (state is CompanyProfileLoaded) {
          _fillControllers(state.company);
        }
      },
      child: BlocBuilder<CompanyProfileBloc, CompanyProfileState>(
        buildWhen: (previous, current) => current is CompanyProfileLoaded,
        builder: (context, state) {
          if (state is CompanyProfileError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          } else if (state is CompanyProfileLoaded) {
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: _buildAppBar(state.company),
              body: _buildBody(state),
            );
          }
          return const LoadingWidget(title: '');
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Company company) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const NavigationButton(chosenIdx: 1),
          ValueListenableBuilder<bool>(
            valueListenable: isEditing,
            builder: (_, editing, __) => editing
                ? Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () => _saveChanges(company),
                ),
                IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: () => isEditing.value = false,
                ),
              ],
            )
                : IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => isEditing.value = true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(CompanyProfileLoaded state) {
    final c = state.company;
    final p = state.posts;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StartupHeader(name: '${c.typeOfRegistration} ${c.name}', sphere: c.sphere),
                  const SizedBox(height: 16),
                  ContactInfoCard(
                    isEditing: isEditing,
                    phoneController: _controllers['phone']!,
                    emailController: _controllers['email']!,
                    websiteController: _controllers['website']!,
                    locationController: _controllers['location']!,
                    ratingController: TextEditingController(text: '4.5'),
                    statusController: TextEditingController(text: 'Публичный'),
                    teamController: TextEditingController(text: '1 чел.'),
                    fundingController: _controllers['required']!,
                  ),
                  const SizedBox(height: 24),
                  _buildTabs(),
                  SizedBox(
                    height: 600,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        StartupAboutTab(isEditing: isEditing, controller: _controllers['description']!),
                        TeamTab(cards: cards, isLoading: _isLoadingTeam),
                        PostsList(posts: p, onAdd: () => context.go('/create_post')),
                        MetricsTabEditable(
                          isEditing: isEditing,
                          revenueController: _controllers['revenue']!,
                          clientsController: _controllers['clients']!,
                          receiptController: _controllers['receipt']!,
                          cacController: _controllers['cac']!,
                          ltvController: _controllers['ltv']!,
                          incomeController: _controllers['income']!,
                        ),
                        InvestmentTabEditable(
                          isEditing: isEditing,
                          offeredController: _controllers['offered']!,
                          requiredController: _controllers['required']!,
                          roundController: _controllers['round']!,
                          shareController: _controllers['share']!,
                          modelController: _controllers['model']!,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorColor: Colors.white,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white54,
      tabs: const [
        Tab(text: 'О стартапе'),
        Tab(text: 'Команда'),
        Tab(text: 'Обновления'),
        Tab(text: 'Метрики'),
        Tab(text: 'Инвестиции'),
      ],
    );
  }

  void _saveChanges(Company oldCompany) {
    try {
      String? sanitize(String text, {String? placeholder}) {
        final t = text.trim();
        return (t.isEmpty || t == placeholder) ? null : t;
      }

      final w = _controllers;
      final website = sanitize(w['website']!.text, placeholder: 'Не указан');
      final email = w['email']!.text.trim();

      final urlRegex = RegExp(r'^(https?:\/\/)?([\w\-]+\.)+[a-zA-Z]{2,}(\/\S*)?$');
      if (website != null && !urlRegex.hasMatch(website)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Некорректный URL сайта')),
        );
        return;
      }

      final updated = oldCompany.copyWith(
        phoneNumber: sanitize(w['phone']!.text, placeholder: 'Не указан'),
        email: email,
        website: website,
        location: sanitize(w['location']!.text, placeholder: 'Не указан'),
        description: sanitize(w['description']!.text, placeholder: 'Описание отсутствует'),
        investmentOffered: double.tryParse(w['offered']!.text),
        investmentRequired: double.tryParse(w['required']!.text),
        investmentRound: sanitize(w['round']!.text),
        businessModel: sanitize(w['model']!.text),
        clients: int.tryParse(w['clients']!.text),
        totalRevenue: double.tryParse(w['revenue']!.text),
        midReceipt: double.tryParse(w['receipt']!.text),
        CAC: double.tryParse(w['cac']!.text),
        LTV: double.tryParse(w['ltv']!.text),
        income: double.tryParse(w['income']!.text),
      );

      final share = double.tryParse(w['share']!.text);
      if (share != null && (share < 0 || share > 100)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Доля должна быть от 0 до 100')),
        );
        return;
      }

      context.read<CompanyProfileBloc>().add(UpdateCompanyData(updated));
      isEditing.value = false;
    } catch (e, stack) {
      Talker().handle(e, stack, 'Ошибка при сохранении данных компании');
    }
  }
}


