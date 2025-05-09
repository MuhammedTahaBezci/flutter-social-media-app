import 'package:bundeerv1/features/auth/presentation/components/my_button.dart';
import 'package:bundeerv1/features/auth/presentation/components/my_text_field.dart';
import 'package:bundeerv1/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages; // Giriş sayfasında tıklama olayı

  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// LoginPage'in durum sınıfı
class _LoginPageState extends State<LoginPage> {
  //metin kontrolü(parola-email)
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  void login() {
    // Giriş işlemleri burada yapılacak
    final email = emailController.text; // Email alanından metni alır
    final pw = pwController.text; // Parola alanından metni alır
    // Burada email ve password ile giriş işlemleri yapılabilir

    // auth cubit ile giriş işlemleri yapılabilir
    final AuthCubit authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty && pw.isNotEmpty) {
      // Eğer email ve parola alanları boş değilse giriş yapar
      authCubit.login(email, pw);
    } else {
      // Eğer alanlar boşsa hata mesajı gösterir
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen email ve şifrenizi girin.")),
      );
    }
  }

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
                  "Hoş geldin, seni çok özledik.",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

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

                const SizedBox(height: 25), // Boşluk bırakılır
                // Giriş butonu
                MyButton(onTap: login, text: "Giriş Yap"),

                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "kayıtlı değil misin?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.togglePages, // Kayıt olma sayfasına geçiş
                      child: Text(
                        " Kayıt Ol",
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
