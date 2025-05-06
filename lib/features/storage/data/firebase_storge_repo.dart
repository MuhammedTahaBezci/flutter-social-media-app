import 'dart:io';
import 'dart:typed_data';
import 'package:bundeerv1/features/storage/domain/storage_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorgeRepo implements StorageRepo {
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future<String> uploadProfileImageMobile(String fileName, String path) {
    // TODO: implement uploadProfileImageMobile
    throw UnimplementedError();
  }

  @override
  Future<String> uploadProfileImageWeb(String fileName, Uint8List fileBytes) {
    // TODO: implement uploadProfileImageWeb
    throw UnimplementedError();
  }

  Future<String?> _uplodFile(
    String path,
    String fileName,
    String folder,
  ) async {
    try {
      final file = File(path);

      final storageRef = storage.ref().child('$folder/$fileName');

      final uploadTask = await storageRef.putFile(file);

      final downloadUrl = await uploadTask.ref.getDownloadURL();
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
    } catch (e) {
      return null;
    }
  }
}
