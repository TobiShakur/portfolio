import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';
import 'package:portfolio/features/portfolio/domain/entities/profile_data.dart';

/// Minimal footer strip anchored at the bottom of the final section.
class PortfolioFooterStrip extends StatelessWidget {
  const PortfolioFooterStrip({
    required this.profile,
    required this.onOpenUrl,
    super.key,
  });

  final ProfileData profile;
  final ValueChanged<String> onOpenUrl;

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
          _FooterLink(
            label: 'GitHub',
            onTap: () => onOpenUrl(profile.githubUrl),
          ),
          Text(
            '·',
            style: AppTextStyles.labelSmall(color: AppColors.textMuted),
          ),
          _FooterLink(
            label: 'LinkedIn',
            onTap: () => onOpenUrl(profile.linkedInUrl),
          ),
          Text(
            '·',
            style: AppTextStyles.labelSmall(color: AppColors.textMuted),
          ),
          _FooterLink(
            label: 'Email',
            onTap: () => onOpenUrl(profile.mailtoUrl),
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  const _FooterLink({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
          child: Text(
            widget.label,
            style: AppTextStyles.labelSmall(
              color: _hovered ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
