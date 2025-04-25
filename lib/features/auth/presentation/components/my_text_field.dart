import 'package:flutter/material.dart';

// Özel bir TextField bileşeni – tekrar kullanılabilir form alanı
class MyTextField extends StatelessWidget {
  final TextEditingController
  controller; // Kullanıcının girdiği metni kontrol eder
  final String hintText; // İçeride gösterilecek ipucu yazısı
  final bool obscureText; // Yazı gizlensin mi? (şifre alanları için true olur)

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, // Kontrolcü atanır
      obscureText:
          obscureText, // Yazı gizlenecek mi belirlenir (örn. şifre alanı)
      // Giriş alanı dekorasyonu
      decoration: InputDecoration(
        // Kenarlık: etkin değilken (boşta)
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
          borderRadius: BorderRadius.circular(12),
        ),

        // Kenarlık: üzerine tıklanmışsa (odaklanmışsa)
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: hintText, // İpucu yazısı
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary, // İpucu yazısının rengi
        ),
        fillColor: Theme.of(context).colorScheme.secondary, // Arka plan rengi
        filled: true, // Arka plan rengi etkinleştirildi
      ),
    );
  }
}
