import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';

/// Non-intrusive bottom status toast for link and clipboard feedback.
class FeedbackToast extends StatelessWidget {
  const FeedbackToast({
    required this.message,
    required this.onDismiss,
    super.key,
  });

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: AppColors.sidebarBg,
          borderRadius: BorderRadius.circular(999.0),
          border: Border.all(
            color: AppColors.sidebarBorder,
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.sidebarShadow,
              blurRadius: 20.0,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                message,
                style: AppTextStyles.labelSmall(color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(width: 10.0),
            InkWell(
              onTap: onDismiss,
              borderRadius: BorderRadius.circular(999.0),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.close,
                  size: 16.0,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
