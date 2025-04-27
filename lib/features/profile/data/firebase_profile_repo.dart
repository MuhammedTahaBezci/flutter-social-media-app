import 'package:bundeerv1/features/profile/domain/entities/profile_user.dart';
import 'package:bundeerv1/features/profile/domain/entities/repos/profile_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Firebase üzerinde kullanıcı profili verilerini yöneten repository sınıfı
class FirebaseProfileRepo implements ProfileRepo {
  // Firestore veritabanı instance'ı
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // Kullanıcının profil verilerini Firestore'dan çekmek için kullanılan method
  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      // Firestore'dan belirli bir kullanıcının dökümantasyonunu getir
      final userDoc =
          await firebaseFirestore.collection("users").doc(uid).get();

      // Eğer döküman varsa
      if (userDoc.exists) {
        final userData = userDoc.data(); // Dökümanın verilerini al

        if (userData != null) {
          // Firestore'dan gelen verileri kullanarak bir ProfileUser nesnesi oluştur ve döndür
          return ProfileUser(
            uid: userData['uid'],
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'] ?? "",
          );
        }
      }

      // Eğer döküman yoksa veya veriler null ise null döndür
      return null;
    } catch (e) {
      return null; // Hata durumunda null döndür
    }
  }

  // Kullanıcının profil bilgilerini Firestore üzerinde güncelleyen method
  @override
  Future<void> updateProfile(ProfileUser updatedProfile) {
    try {
      // Firestore'da kullanıcının dökümantasyonunu güncelle
      return firebaseFirestore
          .collection("users")
          .doc(updatedProfile.uid)
          .update({
            "bio": updatedProfile.bio,
            "profileImageUrl": updatedProfile.profileImageUrl,
          });
    } catch (e) {
      throw Exception(e); // Hata durumunda hatayı tekrar fırlat
    }
  }
}
