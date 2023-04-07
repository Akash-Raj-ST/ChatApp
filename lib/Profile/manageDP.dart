import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:image_picker/image_picker.dart';

final picker = ImagePicker();

Future uploadImage(String id) async {
  // Select image from user's gallery
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile == null) {
    safePrint('No image selected');
    return;
  }

  // Upload image with the current time as the key
  final key = DateTime.now().toString();
  final file = File(pickedFile.path);
  try {
    final UploadFileResult result = await Amplify.Storage.uploadFile(
      local: file,
      key: id,
      onProgress: (progress) {
        safePrint('Fraction completed: ${progress.getFractionCompleted()}');
      },
    );
    safePrint('Successfully uploaded image: ${result.key}');
    return await getDownloadUrl(id);
  } on StorageException catch (e) {
    safePrint('Error uploading image: $e');
  }
}

Future<String> getDownloadUrl(String id) async {

  if(! await checkItem(id)) return "";

  try {
    final result = await Amplify.Storage.getUrl(key: id);
    // NOTE: This code is only for demonstration
    // Your debug console may truncate the printed url string
    safePrint('Got URL: ${result.url}');
    return result.url;
  } on StorageException catch (e) {
    safePrint('Error getting download URL: $e');
    return "";
  }
}

Future<bool> checkItem(String id) async {
  try {
    final result = await Amplify.Storage.list();
    final items = result.items;

    for(var item in items){
      if(item.key==id){
        return true;
      }
    }
    safePrint('Got items: $items');
  } on StorageException catch (e) {
    safePrint('Error listing items: $e');
  }
  return false;
}