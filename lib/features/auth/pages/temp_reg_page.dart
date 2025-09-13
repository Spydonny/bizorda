import 'package:bizorda/features/auth/widgets/widgets.dart';
import 'package:bizorda/features/shared/data/data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker/talker.dart';

import '../../../exceptions/api_exceptions.dart';
import '../../shared/data/models/user.dart';
import '../data/repos/auth_repo.dart';

class TempRegPage extends StatefulWidget {
  const TempRegPage({super.key});

  @override
  State<TempRegPage> createState() => _TempRegPageState();
}

class _TempRegPageState extends State<TempRegPage> {
  final _formKey = GlobalKey<FormState>();
  final authRepository = AuthRepository();
  final companyRepo = CompanyRepository();
  final talker = Talker();

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _nationalIDController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  List<Widget> _buildTextFields() {
    return [
      AuthFormField(
          label: 'Юр. Название стартапа',
          controller: _companyNameController
      ),
      AuthFormField(
        label: 'ИИН/БИН',
        controller: _nationalIDController,
        keyboardType: TextInputType.number,
      ),
      AuthFormField(
        label: 'ФИО',
        controller: _fullNameController,
      ),
      AuthFormField(
          label: 'Email',
          controller: _emailController
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthContainer(
          title: 'Зарегистрироваться',
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
                  onSubmit: () => _handleSubmit(context),
                )
              ],
            ),
          ),
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      talker.debug('ФИО: ${_fullNameController.text}');
      talker.debug('БИН/ИИН: ${_nationalIDController.text}');
      talker.debug('Пароль: ${_passwordController.text}');
      talker.debug('Подтверждение пароля: ${_confirmPasswordController.text}');

      // Проверка ИИН
      if (_nationalIDController.text.trim().length != 12) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Формат ИИН некорректен')),
        );
        throw();
      }

      // Проверка совпадения паролей
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пароли не совпадают')),
        );
        throw();
      }

      // Проверка email
      final email = _emailController.text.trim();
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Некорректный email адрес')),
        );
        throw();
      }

      // Определение названия компании и типа регистрации
      final raw_name = _companyNameController.text.split(' ');
      String companyName = raw_name.sublist(1).join();
      String typeReg = raw_name[0];
      if (companyName == '') {
        companyName = raw_name[0];
        typeReg = '_';
      }

      try {
        final company = await companyRepo.createCompany(
          name: companyName,
          email: email,
          sphere: 'Не указан',
          OKED: 'Не указан',
          registrationType: typeReg,
        );

        await authRepository.registerUser(
          companyId: company!.id,
          fullname: _fullNameController.text,
          nationalId: _nationalIDController.text,
          position: 'CEO',
          password: _passwordController.text,
        );
      } on FoundOtherException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Вы уже зарегистрированы')),
        );
        talker.error(e);
        rethrow;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Непредвиденная ошибка')),
        );
        talker.error(e);
        rethrow;
      }

      await Future.delayed(const Duration(milliseconds: 500));
      context.go('/login');
    }
  }

}
