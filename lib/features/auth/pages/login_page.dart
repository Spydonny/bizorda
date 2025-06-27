import 'package:bizorda/features/auth/data/repos/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final authRepository = AuthRepository();

  final TextEditingController _nationalIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthContainer(
          title: 'Войти',
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ..._buildTextFields(),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.go('/register'),
                    child: const Text('Зарегистрироваться'),
                  ),
                ),
                const SizedBox(height: 12),
                AuthButton(
                  title: 'Войти',
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
        label: 'ИИН/БИН',
        controller: _nationalIDController,
        keyboardType: TextInputType.number,
      ),
      AuthFormField(
        label: 'Пароль',
        controller: _passwordController,
        obscureText: true,
      ),
    ];
  }

  void _handleSubmit(BuildContext context) async {
    final shared = await SharedPreferences.getInstance();
    if (_formKey.currentState!.validate()) {
      String? token;
      try {
        token = await authRepository.login(
          nationalID: _nationalIDController.text,
          password: _passwordController.text,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Перепроверьте ИИН или пароль')),
        );
        return;
      }
      Talker().debug(token);
      shared.setString('access_token', token);
      await Future.delayed(Duration(seconds: 30));
      if (!context.mounted) return;
      context.go('/');
      context.go('/');
    }
  }

}
