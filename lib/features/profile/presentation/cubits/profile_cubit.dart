import 'dart:typed_data';

import 'package:bundeerv1/features/profile/domain/entities/repos/profile_repo.dart';
import 'package:bundeerv1/features/profile/presentation/cubits/profile_states.dart';
import 'package:bundeerv1/features/storage/domain/storage_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo strogaRepo;

  // Cubit başlatılırken ilk durum (ProfileInitial) atanıyor
  ProfileCubit({required this.profileRepo, required this.strogaRepo})
    : super(ProfileInitial());

  // Kullanıcı profili verisini Firestore'dan çekmek için fonksiyon
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading()); // Yükleme durumu yayınlanıyor
      // UID ile kullanıcı verisi çekiliyor
      final user = await profileRepo.fetchUserProfile(uid);
      if (user != null) {
        // Kullanıcı bulunduysa Loaded durumu emit edilir
        emit(ProfileLoaded(user));
      } else {
        // Kullanıcı bulunamadıysa hata emit edilir
        emit(ProfileError("Kullanıcı bulunamadı."));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // Kullanıcının profil bilgisini güncellemek için fonksiyon
  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  }) async {
    // Güncelleme işlemi başlarken yükleme durumu emit edilir
    emit(ProfileLoading());

    try {
      final currentUser = await (profileRepo.fetchUserProfile(uid));

      if (currentUser == null) {
        emit(ProfileError("profil güncellemesi için kullanıcı getirilemedi"));
        return;
      }

      // profile fotoğrafı güncelleniyorsa
      String? imageDownloadUrl;

      if (imageWebBytes != null || imageMobilePath != null) {
        // Web ortamında dosya yükleniyorsa
        if (imageWebBytes != null) {
          imageDownloadUrl = await strogaRepo.uploadProfileImageWeb(
            uid,
            imageWebBytes,
          );
        } else if (imageMobilePath != null) {
          // Mobil ortamda dosya yükleniyorsa
          imageDownloadUrl = await strogaRepo.uploadProfileImageMobile(
            imageMobilePath,
            uid,
          );
        }

        if (imageDownloadUrl == null) {
          emit(ProfileError("Profil fotoğrafı yüklenirken hata oluştu."));
          return;
        }
      }

      // Kullanıcıdan gelen yeni biyografi bilgisi ile mevcut kullanıcı bilgileri güncelleniyor
      final updatedProfile = currentUser.copyWith(
        // Eğer yeni biyografi bilgisi verilmemişse mevcut biyografi bilgisi kullanılacak
        newBio: newBio ?? currentUser.bio,

        // Eğer yeni profil fotoğrafı URL'si verilmemişse mevcut profil fotoğrafı URL'si kullanılacak
        // imageDownloadUrl null ise mevcut profil fotoğrafı URL'si kullanılacak
        newProfileImgeUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
      );

      // Firestore'da güncelleme işlemi yapılıyor
      await profileRepo.updateProfile(updatedProfile);

      await fetchUserProfile(uid); // Güncellenmiş profili tekrar getir
    } catch (e) {
      emit(ProfileError("Profil güncellenirken hata oluştu: $e"));
    }
  }
}
