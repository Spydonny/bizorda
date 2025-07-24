import 'package:bizorda/features/profile/widgets/shared/posts_list.dart';
import 'package:bizorda/features/profile/widgets/startup/widgets.dart';
import 'package:bizorda/widgets/navigation_widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talker/talker.dart';

import '../../../widgets/loading/loading_widget.dart';
import '../../shared/data/models/company.dart';
import '../../shared/data/models/user.dart';
import '../logic/bloc/company_profile_bloc.dart';


class StartupProfilePage extends StatefulWidget {
  const StartupProfilePage({super.key, required this.user, required this.token});
  final User user;
  final String token;

  @override
  State<StartupProfilePage> createState() => _StartupProfilePageState();
}

class _StartupProfilePageState extends State<StartupProfilePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  final ValueNotifier<bool> isEditing = ValueNotifier<bool>(false);

  late TextEditingController nameController;
  late TextEditingController sphereController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController websiteController;
  late TextEditingController locationController;
  late TextEditingController descriptionController;
  late TextEditingController offeredController;
  late TextEditingController requiredController;
  late TextEditingController roundController;
  late TextEditingController shareController;
  late TextEditingController modelController;
  late TextEditingController revenueController;
  late TextEditingController clientsController;
  late TextEditingController receiptController;
  late TextEditingController cacController;
  late TextEditingController ltvController;
  late TextEditingController incomeController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    nameController = TextEditingController();
    sphereController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    websiteController = TextEditingController();
    locationController = TextEditingController();
    descriptionController = TextEditingController();
    offeredController = TextEditingController();
    requiredController = TextEditingController();
    roundController = TextEditingController();
    shareController = TextEditingController();
    modelController = TextEditingController();
    revenueController = TextEditingController();
    clientsController = TextEditingController();
    receiptController = TextEditingController();
    cacController = TextEditingController();
    ltvController = TextEditingController();
    incomeController = TextEditingController();

    context.read<CompanyProfileBloc>().add(
      LoadCompanyProfile(
        widget.user.companyId,
        widget.token,
      ),
    );
  }

  @override
  void dispose() {
    selectedIndex.dispose();
    isEditing.dispose();
    nameController.dispose();
    sphereController.dispose();
    phoneController.dispose();
    emailController.dispose();
    websiteController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    offeredController.dispose();
    requiredController.dispose();
    roundController.dispose();
    shareController.dispose();
    modelController.dispose();
    revenueController.dispose();
    clientsController.dispose();
    receiptController.dispose();
    cacController.dispose();
    ltvController.dispose();
    incomeController.dispose();


    context.read<CompanyProfileBloc>().add(
      ResetCompanyProfile(),
    );
    super.dispose();
  }

  void _fillControllers(Company c) {
    void setIfChanged(TextEditingController controller, String newText) {
      if (controller.text != newText) {
        controller.text = newText;
      }
    }

    setIfChanged(nameController, "${c.typeOfRegistration} ${c.name}");
    setIfChanged(sphereController, c.sphere);
    setIfChanged(phoneController, c.phoneNumber ?? 'Не указан');
    setIfChanged(emailController, c.email);
    setIfChanged(websiteController, c.website ?? 'Не указан');
    setIfChanged(locationController, c.location ?? 'Не указан');
    setIfChanged(descriptionController, c.description ?? 'Описание отсутствует');
    setIfChanged(offeredController, c.investmentOffered?.toStringAsFixed(0) ?? '0');
    setIfChanged(requiredController, c.investmentRequired?.toStringAsFixed(0) ?? '0');
    setIfChanged(roundController, c.investmentRound ?? 'Не указан');
    setIfChanged(shareController, (c.investmentOffered ?? 0 / (c.investmentRequired ?? 1)).toStringAsFixed(0));
    setIfChanged(modelController, c.businessModel ?? 'Не указан');
    setIfChanged(revenueController, c.totalRevenue?.toStringAsFixed(0) ?? '0');
    setIfChanged(clientsController, c.clients?.toString() ?? '0');
    setIfChanged(receiptController, c.midReceipt?.toStringAsFixed(0) ?? '0');
    setIfChanged(cacController, c.CAC?.toStringAsFixed(0) ?? '0');
    setIfChanged(ltvController, c.LTV?.toStringAsFixed(0) ?? '0');
    setIfChanged(incomeController, c.income?.toStringAsFixed(0) ?? '0');

  }

  void _saveChanges(Company oldCompany) {
    try {
      String? sanitizeField(String text, {String? placeholder}) {
        final trimmed = text.trim();
        if (trimmed.isEmpty) return null;
        if (placeholder != null && trimmed == placeholder) return null;
        return trimmed;
      }

      final email = emailController.text.trim();
      final websiteText = websiteController.text.trim();
      final website = sanitizeField(websiteText, placeholder: 'Не указан');
      final urlRegex = RegExp(r'^(https?:\/\/)?([\w\-]+\.)+[a-zA-Z]{2,}(\/\S*)?$');

      if (website != null && !urlRegex.hasMatch(website)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Некорректный URL сайта')),
        );
        return;
      }

      // Инвестиционные поля
      final offered = double.tryParse(offeredController.text.trim());
      final required = double.tryParse(requiredController.text.trim());
      final share = double.tryParse(shareController.text.trim());
      final round = sanitizeField(roundController.text);
      final model = sanitizeField(modelController.text);

      // Валидация чисел
      if (offered != null && offered < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Привлечённая сумма не может быть отрицательной')),
        );
        return;
      }

      if (required != null && required < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Требуемая сумма не может быть отрицательной')),
        );
        return;
      }

      if (share != null && (share < 0 || share > 100)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Доля должна быть от 0 до 100')),
        );
        return;
      }

      final revenue = double.tryParse(revenueController.text.trim());
      final clients = int.tryParse(clientsController.text.trim());
      final receipt = double.tryParse(receiptController.text.trim());
      final cac = double.tryParse(cacController.text.trim());
      final ltv = double.tryParse(ltvController.text.trim());
      final income = double.tryParse(incomeController.text.trim());


      final updated = oldCompany.copyWith(
        name: oldCompany.name,
        sphere: oldCompany.sphere,
        phoneNumber: sanitizeField(phoneController.text, placeholder: 'Не указан'),
        email: email,
        website: website,
        location: sanitizeField(locationController.text, placeholder: 'Не указан'),
        description: sanitizeField(descriptionController.text, placeholder: 'Описание отсутствует'),
        investmentOffered: offered,
        investmentRequired: required,
        investmentRound: round,
        businessModel: model,
        clients: clients,
        totalRevenue: revenue,
        midReceipt: receipt,
        CAC: cac,
        LTV: ltv,
        income: income
      );

      context.read<CompanyProfileBloc>().add(UpdateCompanyData(updated));
      isEditing.value = false;
    } catch (e, stack) {
      Talker().handle(e, stack, 'Ошибка при сохранении данных компании');
    }
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
              }
              else if (state is CompanyProfileLoaded) {
                final company = state.company;
                final posts = state.posts;

                return Scaffold(
                  backgroundColor: Colors.black,
                  appBar: AppBar(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NavigationButton(chosenIdx: 1),
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
                  ),
                  body: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                StartupHeader(name: '${company.typeOfRegistration} ${company.name}',
                                    sphere: company.sphere),
                                const SizedBox(height: 16),
                                ContactInfoCard(isEditing: isEditing, phoneController: phoneController,
                                    emailController: emailController, websiteController: websiteController,
                                    locationController: locationController,
                                    ratingController: TextEditingController(text: '4.5'),
                                    statusController: TextEditingController(text: 'Публичный'),
                                    teamController: TextEditingController(text: '1 чел.'),
                                    fundingController: requiredController,
                                ),
                                const SizedBox(height: 24),
                                _buildTabs(),
                                SizedBox(
                                  height: 600,
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      StartupAboutTab(isEditing: isEditing, controller: descriptionController),
                                      ///temp
                                      Center(child: Text('Команда', style: TextStyle(color: Colors.white))),
                                      PostsList(posts: posts, onAdd: () => context.go('/create_post')),

                                      MetricsTabEditable(isEditing: isEditing,
                                          revenueController: revenueController,
                                          clientsController: clientsController,
                                          receiptController: receiptController,
                                          cacController: cacController,
                                          ltvController: ltvController,
                                          incomeController: incomeController),
                                      InvestmentTabEditable(isEditing: isEditing,
                                          offeredController: offeredController,
                                          requiredController: requiredController,
                                          roundController: roundController,
                                          shareController: shareController,
                                          modelController: modelController)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const LoadingWidget(title: '');
            }

        )
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

}


