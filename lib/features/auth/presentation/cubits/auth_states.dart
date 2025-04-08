import 'package:bundeerv1/features/auth/domain/entities/app_user.dart';

// Kimlik doğrulama durumlarını temsil eden soyut (abstract) sınıf
abstract class AuthState {}

// Başlangıç durumu – herhangi bir işlem yapılmamış, ilk durum
class AuthInitial extends AuthState {}

// Yükleniyor durumu – oturum açma/kayıt gibi bir işlem sırasında gösterilir
class AuthLoading extends AuthState {}

// Başarılı kimlik doğrulama sonrası kullanıcıyı temsil eden durum
class Authenticated extends AuthState {
  final AppUser user; // Oturum açmış kullanıcı bilgisi
  Authenticated(this.user);
}

// Kullanıcının oturum açmamış olduğu veya çıkış yaptığı durum
class Unauthenticated extends AuthState {}

// Hata durumu – kimlik doğrulama işlemleri sırasında bir hata oluştuğunda kullanılır
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
