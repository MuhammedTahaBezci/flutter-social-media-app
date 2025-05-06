import 'package:bundeerv1/features/auth/presentation/components/my_text_field.dart';
import 'package:bundeerv1/features/profile/domain/entities/profile_user.dart';
import 'package:bundeerv1/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:bundeerv1/features/profile/presentation/cubits/profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Profil düzenleme sayfası (Stateful Widget çünkü form verileri değişecek)
class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Kullanıcının biyografisini düzenlemek için bir TextEditingController oluşturuyoruz
  final bioTextController = TextEditingController();

  // profil güncelleme işlemi için buton tıklama fonksiyonu
  void updateProfile() async {
    // profil cubit'ini alıyoruz
    final profileCubit = context.read<ProfileCubit>();

    // kullanıcının UID'sini alıyoruz
    if (bioTextController.text.isNotEmpty) {
      // eğer biyografi alanı boş değilse güncelleme işlemi yapıyoruz
      profileCubit.updateProfile(
        uid: widget.user.uid,
        newBio: bioTextController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // Eğer profil güncelleniyorsa, kullanıcıya yüklenme animasyonu gösterilir
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Profil güncelleniyor..."),
                ],
              ),
            ),
          );
        } else {
          // Eğer yüklenme durumu yoksa düzenleme arayüzü gösterilir
          return buildEditPage();
        }
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  // Arayüzün (UI) esas kısmını oluşturan yardımcı fonksiyon
  Widget buildEditPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Düzenle"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: updateProfile, icon: const Icon(Icons.upload)),
        ],
      ),
      body: Column(
        children: [
          const Text("Biyografi"),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyTextField(
              controller: bioTextController,
              // Kullanıcının girdiği değerleri kontrol eder
              hintText: widget.user.bio,
              // Mevcut biyografi varsayılan metin olarak gösterilir
              obscureText: false, // Şifre alanı olmadığı için false
            ),
          ),
        ],
      ),
    );
  }
}
