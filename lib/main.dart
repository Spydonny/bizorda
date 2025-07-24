import 'package:bizorda/features/auth/data/repos/auth_repo.dart';
import 'package:bizorda/features/auth/pages/company_register_page.dart';
import 'package:bizorda/features/profile/logic/bloc/company_profile_bloc.dart';
import 'package:bizorda/routes.dart';
import 'package:bizorda/theme.dart';
import 'package:bizorda/token_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AuthRepository authRepository = AuthRepository();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final isLoggedIn = await authRepository.checkAuth(token ?? '');

  tokenNotifier.value = token ?? '';

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  timeago.setLocaleMessages('ru', timeago.RuMessages());
  runApp(MyRouterWrapper(isLoggedIn: isLoggedIn,));
}

class MyRouterWrapper extends StatefulWidget {
  final bool isLoggedIn;

  const MyRouterWrapper({required this.isLoggedIn, super.key});

  @override
  State<MyRouterWrapper> createState() => _MyRouterWrapperState();
}

class _MyRouterWrapperState extends State<MyRouterWrapper> {
  late GoRouter _router;
  late final VoidCallback _tokenListener;

  @override
  void initState() {
    super.initState();
    _router = createRouter(widget.isLoggedIn);

    _tokenListener = () {
      Talker().debug(tokenNotifier.value);
      setState(() {
        _router = createRouter(widget.isLoggedIn);
      });
    };

    tokenNotifier.addListener(_tokenListener);
  }

  @override
  void dispose() {
    tokenNotifier.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<CompanyProfileBloc>(
              create: (context) => CompanyProfileBloc()
          )
        ],
        child: MyApp(router: _router)
    );
  }
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


