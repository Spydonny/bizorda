import 'package:bizorda/features/profile/widgets/company/company_description_read_only.dart';
import 'package:bizorda/features/profile/widgets/company/company_header_read_only.dart';
import 'package:bizorda/token_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/bloc/company_profile_bloc.dart';
import '../widgets/widgets.dart';

class OthersCompanyProfilePage extends StatefulWidget {
  const OthersCompanyProfilePage({super.key, required this.companyId});
  final String companyId;

  @override
  State<OthersCompanyProfilePage> createState() => _OthersCompanyProfilePageState();
}

class _OthersCompanyProfilePageState extends State<OthersCompanyProfilePage> {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    context.read<CompanyProfileBloc>().add(
      LoadCompanyProfile(
        widget.companyId,
        tokenNotifier.value
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    context.read<CompanyProfileBloc>().add(ResetCompanyProfile());
    selectedIndex.dispose();
    context.read<CompanyProfileBloc>().add(
      ResetCompanyProfile(),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: BlocBuilder<CompanyProfileBloc, CompanyProfileState>(
          builder: (context, state) {

            if (state is CompanyProfileError) {
                return Center(child: Text(state.message),);
            }

            if(state is CompanyProfileLoaded) {
              final company = state.company;
              final posts = state.posts;

              final screens = [
                CompanyDescriptionReadOnly(
                  company: company,
                ),
                PostsList(posts: posts),
                ReviewsList(companyId: widget.companyId, isThemSelf: false,),
                const Placeholder(),
              ];

               return Column(
                 crossAxisAlignment: CrossAxisAlignment.end,
                 children: [
                   CompanyHeaderReadOnly(
                     company: company,
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
               );
            }

            return Center(child: CircularProgressIndicator(),);
          }
      ),
    );
  }
}
