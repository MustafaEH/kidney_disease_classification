import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageOptions {
  static Future<File?> cameraPicker() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      return File(image.path);
    } else {
      return null;
    }
  }

  static Future<File?> galleryPicker() async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        status = await Permission.storage.request();
      } else {
        status = await Permission.photos.request(); // For Android 13+
      }
    } else {
      status = await Permission.photos.request(); // For iOS
    }

    if (status.isGranted) {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      return image != null ? File(image.path) : null;
    } else {
      print("Permission denied: $status");
      return null;
    }
  }
}
