import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bizorda/features/shared/data/models/company.dart';
import 'package:bizorda/features/shared/data/models/user.dart';
import 'package:bizorda/theme.dart';
import 'package:bizorda/widgets/loading/loading_widget.dart';
import 'package:bizorda/widgets/navigation_widgets/navigation_button.dart';
import 'package:go_router/go_router.dart';
import 'package:talker/talker.dart';

import '../logic/bloc/company_profile_bloc.dart';
import '../widgets/widgets.dart';

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key, required this.user, required this.token});
  final User user;
  final String token;

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  final ValueNotifier<bool> isEditing = ValueNotifier<bool>(false);

  late TextEditingController nameController;
  late TextEditingController sphereController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController websiteController;
  late TextEditingController locationController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    sphereController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    websiteController = TextEditingController();
    locationController = TextEditingController();
    descriptionController = TextEditingController();

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
  }

  void _saveChanges(Company oldCompany) {
    try {
      String? sanitizeField(String text) {
        final trimmed = text.trim();
        return (trimmed.isEmpty || trimmed == 'Не указан') ? null : trimmed;
      }

      final email = emailController.text.trim();
      final websiteText = websiteController.text.trim();
      final website = sanitizeField(websiteText);
      final urlRegex = RegExp(r'^(https?:\/\/)?([\w\-]+\.)+[a-zA-Z]{2,}(\/\S*)?$');
      if (website != null && !urlRegex.hasMatch(website)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Некорректный URL сайта')),
        );
        return;
      }

      final updated = oldCompany.copyWith(
        name: sanitizeField(nameController.text) ?? oldCompany.name,
        sphere: sanitizeField(sphereController.text) ?? oldCompany.sphere,
        phoneNumber: sanitizeField(phoneController.text),
        email: email,
        website: website,
        location: sanitizeField(locationController.text),
        description: sanitizeField(descriptionController.text),
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
          } else if (state is CompanyProfileLoaded) {
            final company = state.company;
            final posts = state.posts;

            final screens = [
              CompanyDescription(
                company: company,
                isEditing: isEditing,
                controller: descriptionController,
              ),
              PostsList(posts: posts, onAdd: () => context.go('/create_post')),
              ReviewsList(companyId: widget.user.companyId,),
              const Placeholder(),
            ];

            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                title: Row(
                  children: [
                    const NavigationButton(chosenIdx: 1),
                    const Spacer(),
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
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CompanyHeader(
                    phoneController: phoneController,
                    emailController: emailController,
                    websiteController: websiteController,
                    locationController: locationController,
                    descriptionController: descriptionController,
                    name: nameController.text,
                    sphere: sphereController.text,
                    isEditing: isEditing,
                  ),
                  ProfileTabSwitcher(selectedIndex: selectedIndex),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ValueListenableBuilder<int>(
                      valueListenable: selectedIndex,
                      builder: (_, index, __) => screens[index],
                    ),
                  ),
                ],
              ),
            );
          }
          return const LoadingWidget(title: '');
        },
      ),
    );
  }
}

