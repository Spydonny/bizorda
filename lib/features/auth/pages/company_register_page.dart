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

  // Новые поля состояния
  String _role = 'Инвестор'; // или 'Стартап'
  String? _registrationType; // например, 'ООО', 'ИП'

  // Список вариантов для ComboBox
  final List<String> _registrationTypes = [
    'ООО',
    'ИП',
    'ТОО',
  ];

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
              const SizedBox(height: 8),
              _buildRegistrationTypeCombo(),
              const SizedBox(height: 16),
              _buildRoleRadios('Стартап','Инвестор'),
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
                onSubmit: () => _handleSubmit(context),
              ),
            ],
          ),
        ),
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
        label: 'Корпоративная почта',
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
      ),
      AuthFormField(
        label: 'Сфера',
        controller: _sphereController,
      ),
    ];
  }

  Widget _buildRoleRadios(String text1, String text2) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: Text(text1, style: TextStyle(fontSize: 14)),
            leading: Radio<String>(
              value: text1,
              groupValue: _role,
              onChanged: (value) {
                setState(() => _role = value!);
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text(text2, style: TextStyle(fontSize: 14),),
            leading: Radio<String>(
              value: text2,
              groupValue: _role,
              onChanged: (value) {
                setState(() => _role = value!);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationTypeCombo() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: 'Тип регистрации',
        hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      value: _registrationType,
      items: _registrationTypes
          .map((type) => DropdownMenuItem(
        value: type,
        child: Text(type),
      ))
          .toList(),
      onChanged: (value) => setState(() => _registrationType = value),
      validator: (value) =>
      value == null ? 'Пожалуйста, выберите тип регистрации' : null,
    );
  }

  void _handleSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      Company? company;
      try {
        company = await companyRepo.createCompany(
          name: _nameController.text,
          email: _emailController.text,
          sphere: _sphereController.text,
          OKED: _OKEDController.text,
          registrationType: _registrationType!,
          typeOrg: _role
        );
      } on ArgumentError catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Такая компания уже зарегистрирована')),
        );
        _talker.error('This company is already registered: $e');
        return;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Непредвиденная ошибка, извините')),
        );
        _talker.error('Unexpected error: $e');
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterPage(companyID: company!.id),
        ),
      );
    }
  }
}

