import 'package:bundeerv1/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:bundeerv1/features/home/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Ana sayfa (Home) bileşeni
class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  //UI bileşeni
  @override
  Widget build(BuildContext context) {
    // Scaffold, sayfanın temel yapısını sağlar
    return Scaffold(
      // Uygulama çubuğu (AppBar) bileşeni
      appBar: AppBar(
        title: const Text("Ana Sayfa"), // AppBar başlığı
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

      //drawer bileşeni
      drawer: MyDrawer(), // Yan menü bileşeni
    );
  }
}
