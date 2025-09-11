import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, this.accessToken});
  final String? accessToken;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final logoEnterra = AssetImage('assets/logo/enterra.jpg');

  late Future<bool> _initFuture;
  bool _navigated = false; // 🔹 защита от повторной навигации

  @override
  void initState() {
    super.initState();
    _initFuture = _initSession();
  }

  Future<bool> _initSession() async {
    try {
      debugPrint(widget.accessToken);
      return widget.accessToken != '';
    } catch (e) {
      debugPrint('Error loading session: $e');
      return false; // Default: not authed
    }
  }

  void _navigate(bool isAuthed, BuildContext context) {
    if (_navigated) return;
    _navigated = true;

    final page = isAuthed ? '/' : '/login';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return FutureBuilder<bool>(
      future: _initFuture,
      builder: (context, snapshot) {
        // 🔹 Лоадер
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading(screenWidth, screenHeight);
        }

        // 🔹 Ошибка
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Ошибка сервера",
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _initFuture = _initSession();
                        _navigated = false; // сброс
                      });
                    },
                    child: const Text("Повторить"),
                  ),
                ],
              ),
            ),
          );
        }

        // 🔹 Успешный результат
        final isAuthed = snapshot.data ?? false;
        _navigate(isAuthed, context);

        // Показ временного экрана с логотипом пока идёт навигация
        return _buildLoading(screenWidth, screenHeight);
      },
    );
  }

  Widget _buildLoading(double w, double h) {
    return Scaffold(
      body: Container(
        width: w,
        height: h,
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(image: logoEnterra, height: 80),
              const SizedBox(height: 16),
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
