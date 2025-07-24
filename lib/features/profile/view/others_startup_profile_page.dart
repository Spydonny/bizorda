import 'package:bizorda/features/messages/pages_screens/chat_screen.dart';
import 'package:bizorda/features/profile/widgets/startup/contact_info_card_read_only.dart';
import 'package:bizorda/token_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/loading/loading_widget.dart';
import '../../../widgets/navigation_widgets/navigation_button.dart';
import '../logic/bloc/company_profile_bloc.dart';
import '../widgets/shared/posts_list.dart';
import '../widgets/startup/widgets.dart';

class OthersStartupProfilePage extends StatefulWidget {
  const OthersStartupProfilePage({super.key, required this.companyID});
  final String companyID;

  @override
  State<OthersStartupProfilePage> createState() => _OthersStartupProfilePageState();
}

class _OthersStartupProfilePageState extends State<OthersStartupProfilePage>
    with SingleTickerProviderStateMixin{
  late final TabController _tabController;
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    context.read<CompanyProfileBloc>().add(
      LoadCompanyProfile(
        widget.companyID,
        tokenNotifier.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyProfileBloc, CompanyProfileState>(
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
                                StartupHeader(
                                  name: '${company.typeOfRegistration} ${company.name}',
                                  sphere: company.sphere,
                                  onConnect: () {
                                  },
                                ),
                                const SizedBox(height: 16),
                                ContactInfoCardReadOnly(company: company),
                                const SizedBox(height: 24),
                                _buildTabs(),
                                SizedBox(
                                  height: 600,
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      StartupAboutTab(text: company.description,),
                                      ///temp
                                      Center(child: Text('Команда', style: TextStyle(color: Colors.white))),
                                      PostsList(posts: posts),
                                      MetricsTabReadOnly(company: company),
                                      InvestmentTabReadOnly(company: company)
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



