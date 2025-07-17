import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ButtonVariant { primary, secondary }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? icon;
  final ButtonVariant variant;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;
    final Color effectiveBg =
        backgroundColor ??
        (variant == ButtonVariant.primary ? Colors.blue : Colors.white);
    final Color effectiveText =
        textColor ??
        (variant == ButtonVariant.primary ? Colors.white : Colors.blue);
    final Color effectiveBorder =
        variant == ButtonVariant.primary ? Colors.transparent : Colors.blue;

    final buttonChild =
        isLoading
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20.sp,
                  height: 20.sp,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      variant == ButtonVariant.primary
                          ? Colors.white
                          : Colors.blue,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  label,
                  style: TextStyle(
                    color: effectiveText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
            : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[icon!, SizedBox(width: 8.w)],
                Text(
                  label,
                  style: TextStyle(
                    color: effectiveText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );

    final button =
        variant == ButtonVariant.primary
            ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDisabled ? Colors.grey.shade300 : effectiveBg,
                foregroundColor:
                    isDisabled ? Colors.grey.shade600 : effectiveText,
                padding: REdgeInsets.symmetric(
                  vertical: 16.h,
                  horizontal: 24.w,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: isDisabled ? 0 : 2,
                shadowColor: Colors.black.withOpacity(0.1),
              ),
              onPressed: isDisabled ? null : onPressed,
              child: buttonChild,
            )
            : OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    isDisabled ? Colors.grey.shade600 : effectiveText,
                backgroundColor:
                    isDisabled ? Colors.grey.shade100 : effectiveBg,
                side: BorderSide(color: effectiveBorder, width: 2),
                padding: REdgeInsets.symmetric(
                  vertical: 16.h,
                  horizontal: 24.w,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              onPressed: isDisabled ? null : onPressed,
              child: buttonChild,
            );

    return Semantics(
      button: true,
      label: semanticLabel ?? label,
      child: SizedBox(width: double.infinity, height: 56.h, child: button),
    );
  }
}
