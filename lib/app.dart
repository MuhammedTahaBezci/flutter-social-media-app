import 'package:bundeerv1/features/home/presentation/pages/home_page.dart';
import 'package:bundeerv1/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:bundeerv1/features/auth/presentation/cubits/auth_states.dart';
import 'package:bundeerv1/features/auth/presentation/pages/auth_page.dart';
import 'package:bundeerv1/features/profile/data/firebase_profile_repo.dart';
import 'package:bundeerv1/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:bundeerv1/features/storage/data/firebase_storge_repo.dart';
import 'package:bundeerv1/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bundeerv1/features/auth/data/firebase_auth_repo.dart';

// Uygulamanın kök widget'ı
class MyApp extends StatelessWidget {
  // Firebase üzerinden kimlik doğrulama işlemleri için repository
  final firebaseAuthRepo = FirebaseAuthRepo(); // camelCase kullan

  // Profil işlemlerini yönetecek repository nesnesi
  final firebaseProfileRepo = FirebaseProfileRepo();

  final firebaseStorageRepo =
      FirebaseStorgeRepo(); // Storage işlemleri için repository

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Birden fazla Cubit sağlayıcısını bir arada sunuyoruz
      providers: [
        BlocProvider<AuthCubit>(
          // Uygulama açılır açılmaz kullanıcının giriş yapıp yapmadığını kontrol ediyor
          create:
              (context) => AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),

        BlocProvider<ProfileCubit>(
          // Profil verilerini yönetecek ProfileCubit sağlanıyor
          create:
              (context) => ProfileCubit(
                profileRepo: firebaseProfileRepo,
                strogaRepo:
                    firebaseStorageRepo, // Storage işlemleri için repository
              ), // Storage repo olarak authRepo kullanılıyor
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Debug bandını kaldır
        theme: lightMode, // Uygulama teması light mode olarak ayarlandı
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            print(authState); // Geçerli auth durumunu konsola yazdır

            // Kullanıcı oturum açmamışsa AuthPage'i göster
            if (authState is Unauthenticated) {
              return const AuthPage();
            }

            // Kullanıcı oturum açmışsa HomePages'i göster
            if (authState is Authenticated) {
              return const HomePages();
            }
            // Diğer durumlarda (örneğin ilk yüklenme) yükleme göstergesi göster
            else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
          listener: (context, state) {
            // AuthCubit durumlarına göre dinleyici fonksiyonu
            if (state is AuthError) {
              // Hata durumunda bir hata mesajı göster
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
