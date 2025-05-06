import 'dart:typed_data';

abstract class StorageRepo {
  // Stroge mobil ve web için ayrı upload fonksiyonları var.
  Future<String?> uploadProfileImageMobile(String fileName, String path);

  Future<String?> uploadProfileImageWeb(String fileName, Uint8List fileBytes);
}
