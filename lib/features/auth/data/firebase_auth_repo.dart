import 'package:bundeerv1/features/auth/domain/entities/app_user.dart';
import 'package:bundeerv1/features/auth/domain/repos/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // Şu an oturum açmış olan kullanıcıyı getirir
  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;

    // Eğer kullanıcı oturum açmamışsa, null döner
    if (firebaseUser == null) {
      return null;
    }

    // Kullanıcı oturum açmışsa, AppUser nesnesi oluşturularak döner
    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email!, name: '');
  }

  // E-posta ve şifre ile oturum açma işlemi
  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      // Firebase ile giriş yapılıyor
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // Başarılı girişten sonra AppUser nesnesi oluşturuluyor
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: '',
      );

      return user;
    } catch (e) {
      throw Exception('Oturum açma başarısız: $e');
    }
  }

  // Oturumu kapatma işlemi
  @override
  Future<void> logout() async {
    await firebaseAuth.signOut(); // Firebase oturumu kapatılıyor
  }

  // E-posta ve şifre ile yeni kullanıcı kaydı
  @override
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      // Firebase ile kullanıcı oluşturuluyor
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Yeni kullanıcıdan AppUser nesnesi oluşturuluyor
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );
      // Kullanıcı bilgileri firestore'a kaydediliyor
      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .set(
            user.toJson(),
          ); // AppUser nesnesini JSON formatına çevirip kaydediyoruz

      return user;
    } catch (e) {
      // Hata durumunda özel bir Exception fırlatılıyor
      throw Exception('Oturum açma başarısız: $e');
    }
  }
}
