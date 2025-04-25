import 'package:bundeerv1/features/auth/presentation/pages/login_page.dart';
import 'package:bundeerv1/features/auth/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true; // Giriş sayfasını gösterir
  // Giriş ve kayıt sayfaları arasında geçiş yapar
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage; // Giriş sayfasını tersine çevirir
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        togglePages: togglePages,
        // Giriş sayfasında tıklama olayı
      );
    } else {
      return RegisterPage(
        toglePages: togglePages,
        // Kayıt sayfasında tıklama olayı
      );
    }
  }
}
