import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kidney/providers/language_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.medical_services,
                    size: 30.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  l10n.appTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                Icon(Icons.language, size: 24.sp),
                SizedBox(width: 16.w),
                Text(
                  l10n.language,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: DropdownButtonFormField<String>(
                value: languageProvider.currentLocale.languageCode,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: REdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child: Row(
                      children: [
                        Text('🇺🇸', style: TextStyle(fontSize: 16.sp)),
                        SizedBox(width: 8.w),
                        Text(l10n.english, style: TextStyle(fontSize: 14.sp)),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'ar',
                    child: Row(
                      children: [
                        Text('🇸🇦', style: TextStyle(fontSize: 16.sp)),
                        SizedBox(width: 8.w),
                        Text(l10n.arabic, style: TextStyle(fontSize: 14.sp)),
                      ],
                    ),
                  ),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    languageProvider.changeLanguage(newValue);
                  }
                },
              ),
            ),
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, size: 24.sp),
            title: Text('Exit', style: TextStyle(fontSize: 16.sp)),
            onTap: () {
              Navigator.pop(context);
              // TODO: Add exit functionality
            },
          ),
        ],
      ),
    );
  }
}
