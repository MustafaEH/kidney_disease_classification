import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kidney/core/image_options.dart';
import 'package:kidney/core/routes_manager.dart';
import 'package:kidney/widgets/build_image_preview.dart';
import 'package:kidney/widgets/custom_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? selectedImageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Kidney Scan",
          style: TextStyle(color: Colors.black, fontSize: 18.sp),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildInstructions(),
            SizedBox(height: 20.h),
            if (selectedImageFile != null) ...[
              BuildImagePreview(selectedImageFile: selectedImageFile),
              SizedBox(height: 16.h),
              CustomButton(
                label: "Analyze Kidney",
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RoutesManager.result,
                    arguments: selectedImageFile!.path,
                  );
                },
              ),
              SizedBox(height: 20.h),
            ],
            const Spacer(),
            CustomButton(
              label: "Take Kidney Image",
              onPressed: _showImageSourceDialog,
            ),
            SizedBox(height: 20.h),
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
      setState(() => selectedImageFile = picked);
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
                    await _pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image, size: 24.sp),
                  title: Text('Gallery', style: TextStyle(fontSize: 16.sp)),
                  onTap: () async {
                    await _pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildInstructions() {
    return Text(
      "Capture a clear image of the kidney for analysis.\nEnsure proper lighting and focus for accurate results.",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: const Color(0xFF0D171C),
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildPrimaryButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: REdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      ),
    );
  }
}
