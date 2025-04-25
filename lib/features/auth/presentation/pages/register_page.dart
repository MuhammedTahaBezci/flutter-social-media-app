import 'package:bundeerv1/features/auth/presentation/components/my_button.dart';
import 'package:bundeerv1/features/auth/presentation/components/my_text_field.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? toglePages; // Kayıt sayfasında tıklama olayı

  const RegisterPage({super.key, required this.toglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //metin kontrolü(parola-email-isim)
  // TextEditingController, metin alanlarının içeriğini kontrol etmek için kullanılır
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final pwConfirmController = TextEditingController();
  // Parola doğrulama alanı için kontrolcü

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body
      body: SafeArea(
        // Güvenli alan: çentik, durum çubuğu gibi alanlara taşmaz
        child: Center(
          // Tüm içerikleri ortalar
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // İçerikler dikey olarak sıralanır
              children: [
                //logo
                Icon(
                  Icons.lock_open_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(height: 50), // Boşluk bırakılır
                // Karşılama mesajı
                Text(
                  "Sizin için bir hesap oluşturalım.",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),
                // İsim alanı
                MyTextField(
                  controller: nameController,
                  hintText: "Name",
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ), // Email alanı

                const SizedBox(height: 10), // Boşluk bırakılır
                MyTextField(
                  controller: pwController,
                  hintText: "Parola",
                  obscureText: true, // Şifre alanı true girilen metni gizler
                ), // Parola alanı

                const SizedBox(height: 10), // Boşluk bırakılır
                MyTextField(
                  controller: pwConfirmController,
                  hintText: "Parola Tekrar",
                  obscureText: true, // Şifre alanı true girilen metni gizler
                ), // Parola alanı

                const SizedBox(height: 25), // Boşluk bırakılır
                // Register butonu
                MyButton(onTap: () {}, text: "Kayıt Ol"),

                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Zaten bir hesabın var mı?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.toglePages, // Kayıt olma sayfasına geçiş
                      child: Text(
                        " Giriş Yap",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
