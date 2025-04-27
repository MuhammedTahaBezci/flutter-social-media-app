import 'package:bundeerv1/features/auth/domain/entities/app_user.dart';

// ProfileUser, AppUser'ın üzerine ekstra özellikler ekler: bio ve profil fotoğrafı URL'si.
class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;

  ProfileUser({
    required super.uid,
    required super.email,
    required super.name,
    required this.bio,
    required this.profileImageUrl,
  });

  // copyWith fonksiyonu: var olan bir ProfileUser nesnesinden yeni bir tane üretir, bazı alanları değiştirebilirsin.
  ProfileUser copyWith({String? newBio, String? newProfileImgeUrl}) {
    return ProfileUser(
      uid: uid,
      email: email,
      name: name,
      bio: newBio ?? bio,
      profileImageUrl: newProfileImgeUrl ?? profileImageUrl,
    );
  }

  // toJson fonksiyonu: ProfileUser nesnesini JSON (Map) formatına çevirir.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
    };
  }

  // fromJson factory constructor: JSON verisinden ProfileUser nesnesi üretir.
  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      bio: json['bio'] ?? "",
      profileImageUrl: json['profileImageUrl'] ?? "",
    );
  }
}
