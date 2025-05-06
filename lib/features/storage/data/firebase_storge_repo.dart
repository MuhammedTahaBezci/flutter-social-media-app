import 'dart:io';
import 'dart:typed_data';
import 'package:bundeerv1/features/storage/domain/storage_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Firebase üzerinde dosya yüklemek için somut sınıf.
/// StorageRepo'yu implement eder, böylece hem mobil hem web için yükleme fonksiyonlarını sağlar.
class FirebaseStorgeRepo implements StorageRepo {
  // Firebase Storage örneği (singleton erişim)
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Mobil cihazdan profil fotoğrafı yüklemek için kullanılan fonksiyon.
  @override
  Future<String?> uploadProfileImageMobile(String fileName, String path) {
    return _uplodFile(path, fileName, 'profile_images');
  }

  /// Web ortamından profil fotoğrafı yüklemek için kullanılan fonksiyon.
  @override
  Future<String?> uploadProfileImageWeb(String fileName, Uint8List fileBytes) {
    return _uplodFileBytes(fileBytes, fileName, 'profile_images');
  }

  //   Private Yardımcı fonksiyon: Mobil platformda cihazdan dosya yüklemek için kullanılır.
  /// - path: Dosyanın cihaz üzerindeki yolu
  /// - fileName: Dosya adı
  /// - folder: Firebase Storage içinde dosyanın yükleneceği klasör
  Future<String?> _uplodFile(
    String path,
    String fileName,
    String folder,
  ) async {
    try {
      // Cihazdan dosyayı alır
      final file = File(path);

      // Firebase Storage'da dosyanın yükleneceği referansı oluşturur
      final storageRef = storage.ref().child('$folder/$fileName');
      // Dosyayı Firebase'e yükler
      final uploadTask = await storageRef.putFile(file);
      // Yükleme tamamlandıktan sonra dosyanın erişim URL'sini alır
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl; // Başarılıysa URL'yi döner
    } catch (e) {
      return null;
    }
  }

  Future<String?> _uplodFileBytes(
    Uint8List fileBytes,
    String fileName,
    String folder,
  ) async {
    try {
      final storageRef = storage.ref().child('$folder/$fileName');

      final uploadTask = await storageRef.putData(fileBytes);

      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}
