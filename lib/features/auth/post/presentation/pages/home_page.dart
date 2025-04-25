import 'package:bundeerv1/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ana Sayfa"),
        actions: [
          IconButton(
            onPressed: () {
              context
                  .read<AuthCubit>()
                  .logout(); // AuthCubit'ten çıkış yapma işlemi
              // Çıkış yapma işlemi burada yapılacak
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
