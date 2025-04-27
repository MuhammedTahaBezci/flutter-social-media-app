import 'package:bundeerv1/features/auth/domain/entities/app_user.dart';
import 'package:bundeerv1/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:bundeerv1/features/profile/presentation/components/bio_box.dart';
import 'package:bundeerv1/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:bundeerv1/features/profile/presentation/cubits/profile_states.dart';
import 'package:bundeerv1/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Profil sayfası bileşeni (stateful, çünkü profil verisi değişebilir)
class ProfilePage extends StatefulWidget {
  final String uid; // Profil sayfasına geçerken kullanıcının UID'sini alıyoruz

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Cubit'leri tanımlıyoruz (AuthCubit ve ProfileCubit erişimi)
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  // AuthCubit'ten giriş yapmış kullanıcı bilgisini alıyoruz
  late AppUser? currrentUser = authCubit.currentUser;

  @override
  void initState() {
    super.initState();
    // Sayfa açıldığında, verilen UID ile profil bilgilerini getiriyoruz
    profileCubit.fetchUserProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // Profil verileri başarıyla yüklendiğinde
        if (state is ProfileLoaded) {
          final user = state.profileUser; // Kullanıcı bilgilerini alıyoruz

          return Scaffold(
            appBar: AppBar(
              title: Text(user.name),
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                IconButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EditProfilePage(
                                user: user,
                              ), // Profil düzenleme sayfasına git
                        ),
                      ),
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),

            // Profil bilgileri ekranda gösteriliyor
            body: Column(
              children: [
                Text(
                  user.email,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 25),

                Container(
                  width: 120,
                  height: 120,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 25),

                // "Biyografi" başlığı
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Text(
                        "biyografi",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Kullanıcının biyografi kısmı (BioBox component'i kullanılıyor)
                BioBox(
                  text: user.bio,
                ), // Kullanıcının biyografisini gösteriyoruz

                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 25),
                  child: Row(
                    children: [
                      Text(
                        "paylaşımlar",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state is ProfileLoading) {
          // Veriler yüklenirken loading göstergesi
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (state is ProfileError) {
          return Center(child: Text(state.errorMessage));
        }
        return Container();
      },
    );
  }
}
