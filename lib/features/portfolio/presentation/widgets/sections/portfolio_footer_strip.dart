import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';
import 'package:portfolio/features/portfolio/domain/entities/profile_data.dart';

/// Minimal footer strip anchored at the bottom of `#contact`.
class PortfolioFooterStrip extends StatelessWidget {
  const PortfolioFooterStrip({
    required this.profile,
    required this.onOpenUrl,
    this.onBackToTop,
    super.key,
  });

  final ProfileData profile;
  final ValueChanged<String> onOpenUrl;
  final VoidCallback? onBackToTop;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 14.0),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.borderHairline, width: 1.0),
        ),
      ),
      child: Wrap(
        spacing: 10.0,
        runSpacing: 8.0,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 6.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                profile.fullName,
                style: AppTextStyles.labelSmall(color: AppColors.textSecondary),
              ),
              Text(
                '·',
                style: AppTextStyles.labelSmall(color: AppColors.textMuted),
              ),
              Text(
                profile.roleTitle,
                style: AppTextStyles.labelSmall(color: AppColors.textMuted),
              ),
              Text(
                '·',
                style: AppTextStyles.labelSmall(color: AppColors.textMuted),
              ),
              PortfolioFooterLink(
                label: 'GitHub',
                onTap: () => onOpenUrl(profile.githubUrl),
              ),
              Text(
                '·',
                style: AppTextStyles.labelSmall(color: AppColors.textMuted),
              ),
              PortfolioFooterLink(
                label: 'LinkedIn',
                onTap: () => onOpenUrl(profile.linkedInUrl),
              ),
              Text(
                '·',
                style: AppTextStyles.labelSmall(color: AppColors.textMuted),
              ),
              PortfolioFooterLink(
                label: 'Email',
                onTap: () => onOpenUrl(profile.mailtoUrl),
              ),
            ],
          ),
          if (onBackToTop != null)
            PortfolioFooterLink(
              label: 'Back to top ↑',
              semanticLabel: 'Back to top',
              isButton: true,
              onTap: onBackToTop!,
            ),
        ],
      ),
    );
  }
}

/// Accessible keyboard-focusable link/action with 44x44px hit target & 2px focus ring.
class PortfolioFooterLink extends StatefulWidget {
  const PortfolioFooterLink({
    required this.label,
    required this.onTap,
    super.key,
    this.semanticLabel,
    this.isButton = false,
  });

  final String label;
  final VoidCallback onTap;
  final String? semanticLabel;
  final bool isButton;

  @override
  State<PortfolioFooterLink> createState() => _PortfolioFooterLinkState();
}

class _PortfolioFooterLinkState extends State<PortfolioFooterLink> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final active = _hovered || _focused;

    return Semantics(
      link: !widget.isButton,
      button: widget.isButton,
      label: widget.semanticLabel ?? widget.label,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onTap();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: Container(
            constraints: const BoxConstraints(
              minWidth: AppSpacing.minTouchTarget,
              minHeight: AppSpacing.minTouchTarget,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: _focused
                  ? Border.all(color: AppColors.accentEngineering, width: 2.0)
                  : null,
            ),
            child: Text(
              widget.label,
              style: AppTextStyles.labelSmall(
                color: active ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
