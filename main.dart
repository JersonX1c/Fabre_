 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme_provider.dart';
import 'login.dart';
import 'signup.dart';
import 'home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.themeMode,
          initialRoute: '/login',
          routes: {
            '/login': (context) => LoginScreen(
                  onLoginSuccess: () =>
                      Navigator.pushReplacementNamed(context, '/home'),
                ),
            '/signup': (context) => const SignUpScreen(),
            '/home': (context) => const HomeScreen(), // dito mo lalagay yung Weather UI
          },
        );
      },
    );
  }
}
