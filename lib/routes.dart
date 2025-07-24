import 'package:bizorda/features/auth/data/repos/auth_repo.dart';
import 'package:bizorda/features/auth/pages/company_register_page.dart';
import 'package:bizorda/features/auth/pages/login_page.dart';
import 'package:bizorda/features/feed/pages/feed_page.dart';
import 'package:bizorda/features/main/main_page.dart';
import 'package:bizorda/features/profile/view/company_profile_page.dart';
import 'package:bizorda/features/profile/view/create_post_screen.dart';
import 'package:bizorda/features/profile/view/startup_profile_page.dart';
import 'package:bizorda/features/settings/settings_page.dart';
import 'package:bizorda/features/shared/data/models/user.dart';
import 'package:bizorda/token_notifier.dart';
import 'package:bizorda/widgets/navigation_widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker/talker.dart';

import 'features/messages/pages_screens/messages_page.dart';

Widget _tempPage(int idx) {
  return Scaffold(
    appBar: AppBar(
      leading: NavigationButton(chosenIdx: idx),
    ),
    body: Center(child: Text('Page $idx')),
  );
}

/// Wraps a protected page that requires a user
class ProtectedRoute extends StatelessWidget {
  final Widget Function(BuildContext, User) builder;
  final String token;

  const ProtectedRoute({
    super.key,
    required this.builder,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthRepository();

    return FutureBuilder<User?>(
      future: authRepo.getCurrentUser(token),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            color: Colors.black,
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user != null) {
          return builder(context, user);
        } else {
          Future.microtask(() => context.go('/login'));
          return const SizedBox.shrink();
        }
      },
    );
  }
}

/// Helper to build a GoRoute wrapped in `ProtectedRoute`
GoRoute buildProtectedRoute({
  required String path,
  required String token,
  required Widget Function(BuildContext, User) builder,
}) {
  Talker().debug('Token in ProtectedRoute $token');
  return GoRoute(
    path: path,
    builder: (context, state) => ProtectedRoute(
      token: token,
      builder: builder,
    ),
  );
}

/// Define all your routes here

GoRouter createRouter(bool isLoggedIn) {
  final protectedPagePaths = [
    '/asaa',
    '/op',
    '/asa',
    '/assss',
    '/docs',
    '/a',
  ];

  final protectedPageBuilders = List<Widget Function(BuildContext, User)>.generate(
    protectedPagePaths.length,
        (idx) => (_, __) => _tempPage(idx),
  );

  return GoRouter(
    initialLocation: tokenNotifier.value.isNotEmpty ? '/' : '/login',
    refreshListenable: tokenNotifier, // 🔄 Auto-refresh when token changes
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, __) => const CompanyRegisterPage()),

      ...List.generate(protectedPagePaths.length, (i) {
        return buildProtectedRoute(
          path: protectedPagePaths[i],
          token: tokenNotifier.value, // ⛽ Always latest token
          builder: protectedPageBuilders[i],
        );
      }),

      buildProtectedRoute(
        path: '/profile',
        token: tokenNotifier.value,
        builder: (_, user) {
          return ValueListenableBuilder<String>(
            valueListenable: typeNotifier,
            builder: (context, type, _) {
              if (type == 'Стартап') {
                return StartupProfilePage(user: user, token: tokenNotifier.value,);
              } else if (type == 'Бизнес') {
                return CompanyProfilePage(user: user, token: tokenNotifier.value,);
              } else {
                return const Center(child: Text('Неизвестный тип организации'));
              }
            },
          );
        },
      ),

      buildProtectedRoute(
        path: '/create_post',
        token: tokenNotifier.value,
        builder: (_, __) => CreatePostScreen(token: tokenNotifier.value),
      ),
      buildProtectedRoute(
        path: '/messages',
        token: tokenNotifier.value,
        builder: (_, user) => MessagesPage(user: user, token: tokenNotifier.value,),
      ),
      buildProtectedRoute(
        path: '/settings',
        token: tokenNotifier.value,
        builder: (_, user) => SettingsPage(user: user,),
      ),
      buildProtectedRoute(
        path: '/',
        token: tokenNotifier.value,
        builder: (_, __) => MainPage(),
      ),
      buildProtectedRoute(
        path: '/feed',
        token: tokenNotifier.value,
        builder: (_, __) => FeedPage(token: tokenNotifier.value,),
      ),
    ],
  );
}
