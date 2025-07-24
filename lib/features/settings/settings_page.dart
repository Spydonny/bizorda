import 'package:bizorda/features/shared/data/models/user.dart';
import 'package:bizorda/features/shared/data/repos/company_repo.dart';
import 'package:bizorda/token_notifier.dart';
import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.user});
  final User user;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _companyRepo = CompanyRepository();

  bool isStartup = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isStartup = typeNotifier.value == 'Стартап';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: NavigationButton(chosenIdx: 5),
        title: Text('Настройки'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Switch(value: isStartup, onChanged: (newValue) {

              if(newValue){
                _companyRepo.updateCompany(
                    companyId: widget.user.companyId,
                    data: {"typeOrg": "Стартап"}
                );
                typeNotifier.value = "Стартап";
              } else {
                _companyRepo.updateCompany(
                    companyId: widget.user.companyId,
                    data: {"typeOrg": "Бизнес"});
                typeNotifier.value = "Бизнес";
              }
              setState(() {
                isStartup = !isStartup;
              });
            }),
            SizedBox(width: 15,),
            Text('Стартап мод')
          ],
        ),
      ),
    );
  }
}
