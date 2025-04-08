import 'package:bundeerv1/features/auth/domain/entities/app_user.dart';

// Bu soyut sınıf (abstract class), kimlik doğrulama (authentication) işlemleri için
// bir arayüz (interface) tanımlar. Bu sınıfı uygulayan (implements) sınıflar,
// bu arayüzdeki metotları kendi özel mantıklarıyla gerçekleştirmek zorundadır.
// Bu, farklı kimlik doğrulama yöntemlerinin (örneğin Firebase Auth, kendi özel backend'i vb.)
// aynı arayüz üzerinden kullanılabilmesini sağlar.
abstract class AuthRepo {
  // E-posta ve şifre ile giriş yapma işlemini temsil eden bir asenkron metot.
  // Bu metot, başarılı bir giriş durumunda bir AppUser nesnesi döndürebilir.
  // Giriş başarısız olursa veya herhangi bir hata oluşursa null döndürebilir.
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  );

  // Kullanıcının oturumunu kapatma (logout) işlemini temsil eden bir asenkron metot.
  // Bu metot herhangi bir değer döndürmez (void), sadece oturum kapatma işlemini gerçekleştirir.
  Future<void> logout();

  Future<AppUser?> getCurrentUser();
}
