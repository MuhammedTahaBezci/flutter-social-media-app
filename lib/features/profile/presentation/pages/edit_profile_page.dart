import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:bundeerv1/features/auth/presentation/components/my_text_field.dart';
import 'package:bundeerv1/features/profile/domain/entities/profile_user.dart';
import 'package:bundeerv1/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:bundeerv1/features/profile/presentation/cubits/profile_states.dart';
import 'package:file_picker/file_picker.dart';
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
  PlatformFile? imagePickedFile; // Kullanıcının seçtiği dosya

  Uint8List? webImage; // Web ortamında seçilen dosya için byte dizisi

  // Kullanıcının biyografisini düzenlemek için bir TextEditingController oluşturuyoruz
  final bioTextController = TextEditingController();

  Future<void> pickImage() async {
    // Dosya seçimi için FilePicker kullanıyoruz
    // Platforma göre dosya seçimi yapıyoruz (mobil veya web)
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first; // Seçilen dosyayı alıyoruz

        if (kIsWeb) {
          webImage =
              imagePickedFile!.bytes; // Web ortamında byte dizisini alıyoruz
        }
      });
    }
  }

  // profil güncelleme işlemi için buton tıklama fonksiyonu
  void updateProfile() async {
    // profil cubit'ini alıyoruz
    final profileCubit = context.read<ProfileCubit>();

    // kullanıcının UID'sini alıyoruz
    final String uid = widget.user.uid;
    // biyografi alanını kontrol ediyoruz
    final String? newBio =
        bioTextController.text.isNotEmpty ? bioTextController.text : null;
    // mobil ortamda dosya yolu alıyoruz
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    // web ortamında byte dizisini alıyoruz
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;

    if (imagePickedFile != null || newBio != null) {
      // eğer profil fotoğrafı veya biyografi alanı boş değilse güncelleme işlemi yapıyoruz
      profileCubit.updateProfile(
        uid: uid,
        newBio: newBio,
        imageWebBytes: imageWebBytes,
        imageMobilePath: imageMobilePath,
      );
    } else {
      Navigator.pop(context); // Eğer her iki alan da boşsa sayfayı kapatıyoruz
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
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              // Profil fotoğrafını farklı koşullara göre göstermek için ternary (koşullu) yapı kullanılır
              child:
                  // Eğer platform web DEĞİLSE (mobil, masaüstü vs.) ve kullanıcı bir fotoğraf seçmişse:
                  (!kIsWeb && imagePickedFile != null)
                      // Cihazdan alınan fotoğrafı göstermek için Image.file kullanılır
                      ? Image.file(File(imagePickedFile!.path!))
                      // Eğer platform WEB ise ve kullanıcı web'den bir fotoğraf seçmişse:
                      : (kIsWeb && webImage != null)
                      // Web'de bellekteki (Uint8List) fotoğrafı göstermek için Image.memory kullanılır
                      ? Image.memory(webImage!)
                      // Eğer kullanıcı yeni bir fotoğraf seçmediyse (hem mobil hem web için),
                      // kullanıcının mevcut profil fotoğrafı URL'den alınarak gösterilir
                      : CachedNetworkImage(
                        // Kullanıcının profil resmi URL'si
                        imageUrl: widget.user.profileImageUrl,

                        imageBuilder:
                            (context, ImageProvider) =>
                                Image(image: ImageProvider),
                      ),
            ),
          ),

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
