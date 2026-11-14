import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';

enum PortfolioButtonVariant {
  primary,
  secondary,
  accentPill,
}

/// Interactive button with 46px+ touch target, hover state, and keyboard focus.
class PortfolioActionButton extends StatefulWidget {
  const PortfolioActionButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = PortfolioButtonVariant.secondary,
    this.trailingIcon,
    this.accentColor,
    this.height = 46.0,
    this.horizontalPadding = 18.0,
  });

  final String label;
  final VoidCallback onPressed;
  final PortfolioButtonVariant variant;
  final IconData? trailingIcon;
  final Color? accentColor;
  final double height;
  final double horizontalPadding;

  @override
  State<PortfolioActionButton> createState() => _PortfolioActionButtonState();
}

class _PortfolioActionButtonState extends State<PortfolioActionButton> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final active = _isHovered || _isFocused;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 160);

    final Color background;
    final Color borderColor;
    final Color foregroundColor;
    final double radius;

    switch (widget.variant) {
      case PortfolioButtonVariant.primary:
        background = active ? const Color(0xFFFFFFFF) : AppColors.textPrimary;
        borderColor = active ? const Color(0xFFFFFFFF) : AppColors.textPrimary;
        foregroundColor = AppColors.ctaInkOnAccent;
        radius = 10.0;
      case PortfolioButtonVariant.secondary:
        background =
            active ? AppColors.bgSurfaceElevated : AppColors.bgSurface;
        borderColor = active ? AppColors.borderFocus : AppColors.borderHairline;
        foregroundColor = AppColors.textPrimary;
        radius = 10.0;
      case PortfolioButtonVariant.accentPill:
        final accent = widget.accentColor ?? AppColors.accentEngineering;
        background = active ? Color.lerp(accent, Colors.white, 0.12)! : accent;
        borderColor = accent;
        foregroundColor = AppColors.ctaInkOnAccent;
        radius = 999.0;
    }

    return Semantics(
      button: true,
      label: widget.label,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (hovered) => setState(() => _isHovered = hovered),
        onShowFocusHighlight: (focused) => setState(() => _isFocused = focused),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed();
              return null;
            },
          ),
        },
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeOutCubic,
            constraints: BoxConstraints(
              minHeight: widget.height,
              minWidth: 44.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: widget.horizontalPadding,
              vertical: 11.0,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: borderColor, width: 1.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.buttonLabel(color: foregroundColor),
                  ),
                ),
                if (widget.trailingIcon != null) ...[
                  const SizedBox(width: 8.0),
                  Icon(
                    widget.trailingIcon,
                    size: 16.0,
                    color: foregroundColor,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
