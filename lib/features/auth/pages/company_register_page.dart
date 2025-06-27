import 'package:bizorda/features/auth/pages/register_page.dart';
import 'package:bizorda/features/shared/data/repos/company_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker/talker.dart';
import '../../shared/data/models/company.dart';
import '../widgets/widgets.dart';

class CompanyRegisterPage extends StatefulWidget {
  const CompanyRegisterPage({super.key});

  @override
  State<CompanyRegisterPage> createState() => _CompanyRegisterPageState();
}

class _CompanyRegisterPageState extends State<CompanyRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final companyRepo = CompanyRepository();
  final _talker = Talker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _OKEDController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sphereController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthContainer(
          title: 'Данные компании',
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ..._buildTextFields(),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('У вас уже есть аккаунт?'),
                  ),
                ),
                const SizedBox(height: 12),
                AuthButton(
                  title: 'Далее',
                  onSubmit: () {_handleSubmit(context);},
                )
              ],
            ),
          )
      ),
    );
  }

  List<Widget> _buildTextFields() {
    return [
      AuthFormField(
        label: 'Название компании (ЮР)',
        controller: _nameController,
      ),
      AuthFormField(
        label: 'ОКЭД',
        controller: _OKEDController,
      ),
      AuthFormField(
        label: 'Корпаративная почта',
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
      ),
      AuthFormField(
        label: 'Сфера',
        controller: _sphereController,
      ),
    ];
  }

  void _handleSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      Company? company;
      try {
        company = await companyRepo.createCompany(
            name: _nameController.text, email: _emailController.text,
            sphere: _sphereController.text, OKED: _OKEDController.text
        );
      } on ArgumentError catch(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Такая компания уже зарегистрирована')));
        _talker.error('This company is already registered: $e');
        return;
      } catch(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Непредвиденная ошибка извините')));
        _talker.error('Unexpected error: $e');
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage(companyID: company!.id) ));
    }
  }
}
