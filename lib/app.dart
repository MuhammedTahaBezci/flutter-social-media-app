import 'package:bundeerv1/features/auth/post/presentation/pages/home_page.dart';
import 'package:bundeerv1/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:bundeerv1/features/auth/presentation/cubits/auth_states.dart';
import 'package:bundeerv1/features/auth/presentation/pages/auth_page.dart';
import 'package:bundeerv1/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bundeerv1/features/auth/data/firebase_auth_repo.dart';

class MyApp extends StatelessWidget {
  final authRepo = FirebaseAuthRepo(); // camelCase kullan

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            print(authState);
            if (authState is Unauthenticated) {
              return const AuthPage(); // Kullanıcı oturum açmamışsa AuthPage'i göster
            }
            if (authState is Authenticated) {
              return const HomePages(); // Kullanıcı oturum açmışsa AuthPage'i göster
            }
            //loding
            else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
          listener: (context, state) {},
        ),
      ),
    );
  }
}
