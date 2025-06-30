import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kidney/core/image_options.dart';
import 'package:kidney/widgets/build_image_preview.dart';
import 'package:kidney/widgets/custom_button.dart';
import 'package:kidney/core/api_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  File? selectedImage;
  PredictionResult? predictionResult;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final imagePath = arguments?['imagePath'] as String?;
    final prediction = arguments?['prediction'] as PredictionResult?;

    final imageFile =
        selectedImage ?? (imagePath != null ? File(imagePath) : null);
    final result = predictionResult ?? prediction;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.scanResult,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: REdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (result != null) ...[
                      _buildPredictionHeader(result),
                      SizedBox(height: 20.h),
                      _buildConfidenceIndicator(result.confidence, l10n),
                      SizedBox(height: 20.h),
                    ] else ...[
                      Text(
                        l10n.noResultsAvailable,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],

                    BuildImagePreview(selectedImageFile: imageFile),

                    SizedBox(height: 20.h),

                    if (result != null) ...[
                      _buildPredictionMessage(result),
                      SizedBox(height: 30.h),
                      _buildRecommendations(result.recommendations, l10n),
                      SizedBox(height: 20.h),
                    ] else ...[
                      Text(
                        l10n.unableToProcess,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Padding(
              padding: REdgeInsets.all(16.w),
              child: CustomButton(
                label: l10n.retakeScan,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionHeader(PredictionResult result) {
    Color textColor;
    IconData iconData;

    // Handle validation errors
    if (result.disease.toLowerCase() == 'invalid image') {
      textColor = Colors.orange;
      iconData = Icons.warning_amber;
    } else if (result.disease.toLowerCase() == 'normal') {
      textColor = Colors.green;
      iconData = Icons.check_circle;
    } else {
      textColor = Colors.red;
      iconData = Icons.warning;
    }

    final l10n = AppLocalizations.of(context)!;
    String localizedDisease = _localizedDisease(result.disease, l10n);

    return Row(
      children: [
        Icon(iconData, color: textColor, size: 32.sp),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            localizedDisease,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }

  String _localizedDisease(String disease, AppLocalizations l10n) {
    switch (disease.toLowerCase()) {
      case 'cyst':
        return l10n.diseaseCyst;
      case 'tumor':
        return l10n.diseaseTumor;
      case 'normal':
        return l10n.diseaseNormal;
      case 'invalid image':
        return l10n.diseaseInvalidImage;
      case 'unknown':
        return l10n.diseaseUnknown;
      default:
        return disease;
    }
  }

  Widget _buildConfidenceIndicator(double confidence, AppLocalizations l10n) {
    return Container(
      padding: REdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.confidenceLevel,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(height: 8.h),
          LinearProgressIndicator(
            value: confidence,
            backgroundColor: Colors.blue.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(height: 4.h),
          Text(
            "${(confidence * 100).toStringAsFixed(1)}%",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.blue.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionMessage(PredictionResult result) {
    Color backgroundColor;
    Color borderColor;

    if (result.disease.toLowerCase() == 'invalid image') {
      backgroundColor = Colors.orange.shade50;
      borderColor = Colors.orange.shade200;
    } else if (result.disease.toLowerCase() == 'normal') {
      backgroundColor = Colors.green.shade50;
      borderColor = Colors.green.shade200;
    } else {
      backgroundColor = Colors.orange.shade50;
      borderColor = Colors.orange.shade200;
    }

    final l10n = AppLocalizations.of(context)!;
    String localizedMessage = _localizedMessage(result.message, l10n);

    return Container(
      padding: REdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        localizedMessage,
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 16.sp, color: Colors.black87, height: 1.4),
      ),
    );
  }

  String _localizedMessage(String message, AppLocalizations l10n) {
    switch (message.trim()) {
      case "Possible indication of cyst detected. Consider consulting a healthcare professional for further evaluation.":
        return l10n.msgCystDetected;
      default:
        return message;
    }
  }

  Widget _buildRecommendations(
    List<String> recommendations,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recommendations,
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 12.h),
        ...recommendations
            .map(
              (recommendation) => Padding(
                padding: REdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        _localizedRecommendation(recommendation, l10n),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  String _localizedRecommendation(
    String recommendation,
    AppLocalizations l10n,
  ) {
    switch (recommendation.trim()) {
      case "Consult a nephrologist immediately":
        return l10n.recConsultNephrologist;
      case "Follow up with additional tests":
        return l10n.recFollowUpTests;
      case "Monitor symptoms closely":
        return l10n.recMonitorSymptoms;
      case "Maintain prescribed medications if any":
        return l10n.recMaintainMeds;
      case "Monitor cyst size regularly":
        return l10n.recMonitorCystSize;
      case "Avoid activities that may cause trauma to the kidney area":
        return l10n.recAvoidTrauma;
      default:
        return recommendation;
    }
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
