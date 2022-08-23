import 'dart:io';

import 'package:chatapp/models/cloud_storage_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  Future<CloudStorageResult?> uploadImage({
    required File imageToUpload,
    required String title,
  }) async {
    var imageFileName =
        title + DateTime.now().microsecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference firebaseStorageRef = storage.ref().child(imageFileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);
    uploadTask.then((res) async {
      String url = await res.ref.getDownloadURL();
      return CloudStorageResult(imgUrl: url, imageFileName: imageFileName);
    });
    return null;
  }
}
