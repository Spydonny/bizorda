import 'package:bizorda/exceptions/exceptions.dart';
import 'package:bizorda/features/auth/data/repos/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker/talker.dart';
import '../../shared/data/models/user.dart';
import '../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.companyID});
  final String companyID;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final talker = Talker();
  final AuthRepository authRepository = AuthRepository();

  // Контроллеры для каждого текстового поля
  final _fullNameController = TextEditingController();
  final _iinController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Освобождаем ресурсы
    _fullNameController.dispose();
    _iinController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AuthContainer(
        title: 'Ваши данные',
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
                title: 'Зарегестрироваться',
                onSubmit: (){ _handleSubmit(context);},
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTextFields() {
    return [
      AuthFormField(
        label: 'ФИО',
        controller: _fullNameController,
      ),
      AuthFormField(
        label: 'БИН/ИИН',
        controller: _iinController,
        keyboardType: TextInputType.number,
      ),
      AuthFormField(
        label: 'Номер телефона',
        controller: _phoneController,
        keyboardType: TextInputType.phone,
      ),
      AuthFormField(
        label: 'Пароль',
        controller: _passwordController,
        obscureText: true,
      ),
      AuthFormField(
        label: 'Подтверждение пароля',
        controller: _confirmPasswordController,
        obscureText: true,
      ),
    ];
  }

  void _handleSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      User? user;

      // Пример доступа к значениям:
      talker.debug('ФИО: ${_fullNameController.text}');
      talker.debug('БИН/ИИН: ${_iinController.text}');
      talker.debug('Телефон: ${_phoneController.text}');
      talker.debug('Пароль: ${_passwordController.text}');
      talker.debug('Подтверждение пароля: ${_confirmPasswordController.text}');
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Пароли не совпадают')));
      }
      try {

        user = await authRepository.registerUser(companyId: widget.companyID,
            fullname: _fullNameController.text, nationalId: _iinController.text,
            position: 'CEO', password: _passwordController.text);

      } on FoundOtherException catch(e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Вы уже зарегистрированы')));
        talker.error(e);
        return;

      } catch(e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Непредвиденная ошибка')));
        talker.error(e);
        return;
      }
      await Future.delayed(const Duration(milliseconds: 500));
      context.go('/login');
    }
  }
}
