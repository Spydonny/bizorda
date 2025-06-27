import 'package:bizorda/features/auth/data/repos/auth_repo.dart';
import 'package:bizorda/features/feed/data/repos/post_repo.dart';
import 'package:bizorda/features/profile/widgets/create_post_screen.dart';
import 'package:bizorda/features/shared/data/repos/company_repo.dart';
import 'package:bizorda/widgets/loading/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme.dart';
import '../feed/data/models/post.dart';
import '../shared/data/models/company.dart';
import '../shared/data/models/user.dart';
import 'widgets/widgets.dart'; // импортируем новый файл

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key, required this.user});
  final User user;

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  late final String token;

  late final PostRepository postRepo;
  final CompanyRepository companyRepo = CompanyRepository();

  Future<List<Post>>? futurePosts;
  Future<Company>? futureCompany;
  late Company editableCompany;

  // Контроллеры для редактирования
  late TextEditingController nameController,
      sphereController,
      phoneController,
      emailController,
      websiteController,
      locationController,
      descriptionController;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final id = widget.user.companyId;
    token = (await SharedPreferences.getInstance()).getString(
        'access_token') ?? '';
    postRepo = PostRepository(token: token);

    setState(() {
      futurePosts = postRepo.getPostsByCompany(id);
      futureCompany = companyRepo.getCompanyById(id).then((c) {
        editableCompany = c;
        _initControllers(c);
        return c;
      });
    });
  }

  void _initControllers(Company c) {
    nameController = TextEditingController(text: c.name);
    sphereController = TextEditingController(text: c.sphere);
    phoneController = TextEditingController(text: c.phoneNumber ?? '');
    emailController = TextEditingController(text: c.email);
    websiteController = TextEditingController(text: c.website ?? '');
    locationController = TextEditingController(text: c.location ?? '');
    descriptionController = TextEditingController(text: c.description ?? '');
  }

  @override
  void dispose() {
    selectedIndex.dispose();
    nameController.dispose();
    sphereController.dispose();
    phoneController.dispose();
    emailController.dispose();
    websiteController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<(Company, List<Post>)> loadData() async {
    final c = await futureCompany!;
    final p = await futurePosts!;
    return (c, p);
  }

  void _saveChanges() {
    setState(() {
      editableCompany = editableCompany.copyWith(
        name: nameController.text,
        sphere: sphereController.text,
        phoneNumber: phoneController.text,
        email: emailController.text,
        website: websiteController.text,
        location: locationController.text,
        description: descriptionController.text,
      );
      isEditing = false;
      companyRepo.updateCompany(companyId: widget.user.companyId, data: editableCompany.toJson());
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return FutureBuilder<(Company, List<Post>)>(
      future: loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget(title: '');
        } else if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('Нет данных'));
        }

        final company = snapshot.data!.$1;
        final posts = snapshot.data!.$2;

        final List<Widget> screens = [
          CompanyInfo(company: company,),
          PostsList(
            posts: posts,
            onAdd:() => Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePostScreen(token: token))),
          ),
          const ReviewsList(),
          const Placeholder(), // 4-я вкладка
        ];

        return DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(240),
              child: CompanyProfileAppBar(
                companyName: company.name,
                companyDescription: company.sphere,
                phone: company.phoneNumber ?? 'Не указан',
                email: company.email,
                website: company.website ?? 'Не указан',
                location: company.location ?? 'Не указан', isEditing: false,
              ),
            ),
            body: SizedBox(
              width: screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _TabSwitcher(selectedIndex: selectedIndex),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ValueListenableBuilder<int>(
                      valueListenable: selectedIndex,
                      builder: (context, index, _) {
                        return screens[index];
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}

class _TabSwitcher extends StatelessWidget {
  const _TabSwitcher({required this.selectedIndex, });
  final ValueNotifier<int> selectedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<String> tabs = ['О компании', 'Публикации', 'Отзывы'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (context, index, _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(tabs.length, (i) {
              final isSelected = i == index;

              return GestureDetector(
                onTap: () => selectedIndex.value = i,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white12
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tabs[i],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight
                          .normal,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}