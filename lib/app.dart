import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FloatingNavMenu(),
    );
  }
}

class FloatingNavMenu extends StatefulWidget {
  const FloatingNavMenu({super.key});

  @override
  State<FloatingNavMenu> createState() => _FloatingNavMenuState();
}

class _FloatingNavMenuState extends State<FloatingNavMenu> {
  bool _showMenu = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Плавающее меню")),
      body: Stack(
        children: [
          Center(child: Text("Главный экран")),

          // Плавающий контейнер
          if (_showMenu)
            Positioned(
              right: 20,
              bottom: 80,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 200,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.home),
                        title: Text("Главная"),
                        onTap: () {}, // переход
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text("Настройки"),
                        onTap: () {}, // переход
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(_showMenu ? Icons.close : Icons.menu),
        onPressed: () {
          setState(() {
            _showMenu = !_showMenu;
          });
        },
      ),
    );
  }
}
