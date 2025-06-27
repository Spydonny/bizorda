import 'package:bizorda/features/auth/data/repos/auth_repo.dart';
import 'package:bizorda/features/auth/pages/company_register_page.dart';
import 'package:bizorda/features/auth/pages/login_page.dart';
import 'package:bizorda/features/feed/pages/feed_page.dart';
import 'package:bizorda/features/main/main_page.dart';
import 'package:bizorda/features/profile/company_profile_page.dart';
import 'package:bizorda/features/shared/data/models/user.dart';
import 'package:bizorda/widgets/navigation_widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          // Defer navigation to next microtask to avoid setState/build conflict
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
  return GoRoute(
    path: path,
    builder: (context, state) => ProtectedRoute(
      token: token,
      builder: builder,
    ),
  );
}

/// Define all your routes here
GoRouter createRouter(bool isLoggedIn, String? token) {
  token ??= '';

  final protectedPagePaths = [
    '/asaa',
    '/op',
    '/asa',
    '/assss',
    '/docs',
    '/settings',
  ];

  final protectedPageBuilders = List<Widget Function(BuildContext, User)>.generate(
    protectedPagePaths.length,
        (idx) => (_, __) => _tempPage(idx),
  );

  return GoRouter(
    initialLocation: isLoggedIn ? '/' : '/login',
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, __) => const CompanyRegisterPage()),

      ...List.generate(protectedPagePaths.length, (i) {
        return buildProtectedRoute(
          path: protectedPagePaths[i],
          token: token!,
          builder: protectedPageBuilders[i],
        );
      }),

      buildProtectedRoute(
        path: '/profile',
        token: token,
        builder: (_, user) => CompanyProfilePage(user: user),
      ),
      buildProtectedRoute(
        path: '/messages',
        token: token,
        builder: (_, user) => MessagesPage(user: user),
      ),
      buildProtectedRoute(
        path: '/',
        token: token,
        builder: (_, __) => MainPage(),
      ),
      buildProtectedRoute(
        path: '/feed',
        token: token,
        builder: (_, __) => const FeedPage(),
      ),
    ],
  );
}