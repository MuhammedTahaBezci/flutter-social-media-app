import 'package:bundeerv1/features/auth/domain/entities/app_user.dart';
import 'package:bundeerv1/features/auth/domain/repos/auth_repo.dart';
import 'package:bundeerv1/features/auth/presentation/cubits/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// AuthCubit sınıfı, kullanıcı kimlik doğrulama işlemlerini yöneten Cubit sınıfıdır.
// Bloc kütüphanesi kullanılarak, UI ile iş mantığı ayrılır.
class AuthCubit extends Cubit<AuthState> {
  final AuthRepo
  authRepo; // Kimlik doğrulama işlemlerini gerçekleştiren repository
  AppUser? _currentUser; // Anlık oturum açmış kullanıcıyı tutar

  // Constructor: Cubit ilk kez oluşturulurken AuthInitial durumu ile başlatılır
  AuthCubit({required this.authRepo}) : super(AuthInitial());

  // Uygulama açıldığında mevcut kullanıcıyı kontrol eder
  void checkAuth() async {
    final AppUser? user =
        await authRepo.getCurrentUser(); // Şu anki kullanıcı alınır

    if (user != null) {
      _currentUser = user;
      emit(
        Authenticated(user),
      ); // UI'ye "kullanıcı oturum açtı" bilgisi gönderilir
    } else {
      emit(
        Unauthenticated(),
      ); // Kullanıcı yoksa "oturum kapalı" durumu gönderilir
    }
  }

  // Anlık oturum açmış kullanıcıyı döner
  AppUser? get currentUser => _currentUser;

  // Kullanıcının e-posta ve şifre ile oturum açmasını sağlar
  Future<void> login(String email, String pw) async {
    try {
      emit(AuthLoading()); // UI'ye yükleniyor durumu bildirilir
      final user = await authRepo.loginWithEmailPassword(email, pw);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user)); // UI'ye başarılı giriş bilgisi gönderilir
      } else {
        emit(Unauthenticated()); // Kullanıcı null ise başarısız giriş
      }
    } catch (e) {
      emit(AuthError(e.toString())); // Hata mesajı gönderilir
      emit(Unauthenticated()); // UI "giriş başarısız" olarak ayarlanır
    }
  }

  // Yeni kullanıcı kaydı oluşturur
  Future<void> register(String name, String email, String pw) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.registerWithEmailPassword(
        name,
        email,
        pw,
      ); // Kayıt yapılır

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user)); // UI'ye başarılı kayıt bilgisi gönderilir
      } else {
        emit(Unauthenticated()); // Kullanıcı null ise başarısız kayıt
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated()); // UI "kayıt başarısız" olarak ayarlanır
    }
  }

  // Kullanıcının oturumunu kapatır
  Future<void> logout() async {
    authRepo.logout(); // Repository üzerinden çıkış yapılır
    emit(Unauthenticated()); // UI'ye "oturum kapalı" durumu bildirilir
  }
}
