import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kidney/core/api_service.dart';
import 'package:kidney/core/image_options.dart';
import 'package:kidney/core/routes_manager.dart';
import 'package:kidney/providers/language_provider.dart';
import 'package:kidney/widgets/app_drawer.dart';
import 'package:kidney/widgets/build_image_preview.dart';
import 'package:kidney/widgets/custom_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? selectedImageFile;
  bool _isAnalyzing = false;
  bool _isApiAvailable = true;

  @override
  void initState() {
    super.initState();
    _checkApiAvailability();
  }

  Future<void> _checkApiAvailability() async {
    final isAvailable = await ApiService.isApiAvailable();
    setState(() {
      _isApiAvailable = isAvailable;
    });
  }

  Future<void> _debugApiConnection() async {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.checkingApiConnection),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      final isAvailable = await ApiService.isApiAvailable();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isAvailable ? l10n.apiAvailable : l10n.apiNotAvailable,
            ),
            backgroundColor: isAvailable ? Colors.green : Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.debugError(e.toString())),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _analyzeKidney() async {
    if (selectedImageFile == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final result = await ApiService.predictDisease(selectedImageFile!);

      if (mounted) {
        Navigator.pushNamed(
          context,
          RoutesManager.result,
          arguments: {
            'imagePath': selectedImageFile!.path,
            'prediction': result,
          },
        );
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.error(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isArabic;

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: const AppDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            l10n.kidneyScan,
            style: TextStyle(color: Colors.black, fontSize: 18.sp),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                _isApiAvailable ? Icons.wifi : Icons.wifi_off,
                color: _isApiAvailable ? Colors.green : Colors.red,
              ),
              onPressed: _checkApiAvailability,
            ),
            IconButton(
              icon: Icon(Icons.bug_report, color: Colors.blue),
              onPressed: _debugApiConnection,
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: REdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildInstructions(),
                SizedBox(height: 20.h),
                if (!_isApiAvailable) ...[
                  _buildApiWarning(),
                  SizedBox(height: 16.h),
                ],
                if (selectedImageFile != null) ...[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          BuildImagePreview(
                            selectedImageFile: selectedImageFile,
                          ),
                          SizedBox(height: 16.h),
                          CustomButton(
                            label: l10n.analyzeKidney,
                            onPressed: _analyzeKidney,
                            isLoading: _isAnalyzing,
                            backgroundColor:
                                _isApiAvailable ? null : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 80.sp,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            l10n.noImageSelected,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            l10n.takePhotoOrSelect,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                CustomButton(
                  label: l10n.takeKidneyImage,
                  onPressed: _showImageSourceDialog,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
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
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final isRTL = languageProvider.isArabic;

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
                  title: Text(l10n.camera, style: TextStyle(fontSize: 16.sp)),
                  onTap: () async {
                    await _pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image, size: 24.sp),
                  title: Text(l10n.gallery, style: TextStyle(fontSize: 16.sp)),
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
    final l10n = AppLocalizations.of(context)!;
    return Text(
      l10n.instructions,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: const Color(0xFF0D171C),
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildApiWarning() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: REdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              l10n.apiWarning,
              style: TextStyle(color: Colors.red.shade700, fontSize: 15.sp),
            ),
          ),
        ],
      ),
    );
  }
}
