import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kidney/core/image_options.dart';
import 'package:kidney/widgets/build_image_preview.dart';
import 'package:kidney/widgets/custom_button.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    final imagePath = ModalRoute.of(context)?.settings.arguments as String?;
    final imageFile =
        selectedImage ?? (imagePath != null ? File(imagePath) : null);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("Scan Result", style: TextStyle(color: Colors.black)),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "No Kidney Disease Detected",
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20.h),

            BuildImagePreview(selectedImageFile: imageFile),

            SizedBox(height: 20.h),
            Text(
              "Your scan results indicate no signs of kidney disease. "
              "Continue to maintain a healthy lifestyle for optimal kidney function.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16.sp, color: Colors.black87),
            ),

            SizedBox(height: 30.h),
            Text(
              "Personalized Tips",
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500),
            ),

            const Spacer(),

            CustomButton(
              label: "Retake Scan",
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked =
        source == ImageSource.camera
            ? await ImageOptions.cameraPicker()
            : await ImageOptions.galleryPicker();

    if (picked != null) {
      setState(() => selectedImage = picked);
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder:
          (context) => Padding(
            padding: REdgeInsets.symmetric(vertical: 12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt, size: 24.sp),
                  title: Text('Camera', style: TextStyle(fontSize: 16.sp)),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image, size: 24.sp),
                  title: Text('Gallery', style: TextStyle(fontSize: 16.sp)),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
    );
  }
}
