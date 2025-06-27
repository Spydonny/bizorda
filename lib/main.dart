import 'package:bizorda/features/auth/data/repos/auth_repo.dart';
import 'package:bizorda/features/auth/pages/company_register_page.dart';
import 'package:bizorda/routes.dart';
import 'package:bizorda/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AuthRepository authRepository = AuthRepository();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final isLoggedIn = await  authRepository.checkAuth(token ?? '');

  final router = createRouter(isLoggedIn, token);

  timeago.setLocaleMessages('ru', timeago.RuMessages());
  runApp(MyApp(router: router,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});
  final GoRouter router;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}


