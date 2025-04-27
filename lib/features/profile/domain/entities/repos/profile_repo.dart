import 'package:bundeerv1/features/profile/domain/entities/profile_user.dart';

// ProfileRepo, kullanıcı profili ile ilgili yapılacak işlemleri tanımlar
// Bu bir soyut sınıf (abstract class) => sadece kuralları belirler, içerik (gövde) yazmaz
abstract class ProfileRepo {
  // Kullanıcının profil bilgilerini veritabanından getirir
  Future<ProfileUser?> fetchUserProfile(String uid);

  // Kullanıcının profil bilgilerini veritabanında günceller
  Future<void> updateProfile(ProfileUser updatedProfile);
}
