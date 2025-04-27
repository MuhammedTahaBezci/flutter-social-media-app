import 'package:bundeerv1/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:bundeerv1/features/home/components/my_drawer_tile.dart';
import 'package:bundeerv1/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Uygulamanın yan menüsü (Drawer bileşeni)
class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              // Kullanıcı simgesi (profil ikonu gibi)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              // Bölücü çizgi
              Divider(color: Theme.of(context).colorScheme.primary),

              // Ana sayfa butonu
              MyDrawerTile(
                title: "A N A S A Y F A",
                icon: Icons.home,
                onTap:
                    () =>
                        Navigator.of(context).pop(), // Ana sayfaya gitme işlemi
              ),

              // Profil butonu
              MyDrawerTile(
                title: "P R O F İ L",
                icon: Icons.person,
                onTap: () {
                  Navigator.of(context).pop(); // Çık

                  final user = context.read<AuthCubit>().currentUser;
                  // AuthCubit içinden şu an giriş yapmış kullanıcı bilgisini çekiyoruz
                  String? uid = user!.uid;
                  // Kullanıcı nesnesinden uid (kullanıcı ID) bilgisini alıyoruz

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(uid: uid),
                      // Daha sonra ProfilePage sayfasına gidiyoruz ve uid bilgisini sayfaya gönderiyoruz
                    ),
                  );
                },
              ),

              // Arama butonu
              MyDrawerTile(
                title: "A R A",
                icon: Icons.search,
                onTap: () {
                  // Arama sayfası gitme işlemi
                },
              ),

              // Ayarlar butonu
              MyDrawerTile(
                title: "A Y A R L A R",
                icon: Icons.settings,
                onTap: () {
                  // Profil sayfasına gitme işlemi
                },
              ),

              const Spacer(), // Sayfanın altına kadar boşluk bırakır

              MyDrawerTile(
                title: "Ç I K I Ş",
                icon: Icons.logout,
                onTap:
                    () =>
                        context
                            .read<AuthCubit>()
                            .logout(), // AuthCubit'ten çıkış yapma işlemi
              ),
            ],
          ),
        ),
      ),
    );
  }
}
