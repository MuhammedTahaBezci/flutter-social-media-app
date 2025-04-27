import 'package:bundeerv1/features/home/components/my_drawer.dart';
import 'package:flutter/material.dart';

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
      ),

      //drawer bileşeni
      drawer: const MyDrawer(), // Yan menü bileşeni
    );
  }
}
