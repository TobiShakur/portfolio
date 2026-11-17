import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_section_id.dart';

/// Individual 44x44px navigation item inside the floating pill sidebar.
class SidebarNavItem extends StatefulWidget {
  const SidebarNavItem({
    required this.section,
    required this.isActive,
    required this.onTap,
    super.key,
    this.iconAssetPath,
    this.showTooltipOnHover = true,
    this.onHoverChanged,
  });

  final PortfolioSectionId section;
  final bool isActive;
  final VoidCallback onTap;
  final String? iconAssetPath;
  final bool showTooltipOnHover;
  final ValueChanged<bool>? onHoverChanged;

  @override
  State<SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<SidebarNavItem> {
  final FocusNode _focusNode = FocusNode();
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final highlighted = widget.isActive || _isHovered || _isFocused;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration = reduceMotion ? Duration.zero : AppMotion.interactive;
    final tooltipDuration =
        reduceMotion ? Duration.zero : AppMotion.interactive;

    return Semantics(
      button: true,
      selected: widget.isActive,
      label: 'Jump to ${widget.section.navLabel}',
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) {
              if (!_isHovered) {
                setState(() => _isHovered = true);
                widget.onHoverChanged?.call(true);
              }
            },
            onExit: (_) {
              if (_isHovered) {
                setState(() => _isHovered = false);
                widget.onHoverChanged?.call(false);
              }
            },
            child: Focus(
              focusNode: _focusNode,
              onFocusChange: (focused) {
                if (_isFocused != focused) {
                  setState(() => _isFocused = focused);
                }
              },
              onKeyEvent: (_, event) {
                if (event is KeyDownEvent &&
                    (event.logicalKey == LogicalKeyboardKey.enter ||
                        event.logicalKey == LogicalKeyboardKey.space)) {
                  widget.onTap();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: GestureDetector(
                onTap: widget.onTap,
                child: AnimatedContainer(
                  duration: duration,
                  curve: AppMotion.standardCurve,
                  width: AppSpacing.sidebarItemSize,
                  height: AppSpacing.sidebarItemSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: highlighted
                        ? AppColors.bgSurfaceElevated
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: _isFocused
                          ? AppColors.accentEngineering
                          : (highlighted
                              ? AppColors.borderFocus
                              : Colors.transparent),
                      width: _isFocused ? 2.0 : 1.0,
                    ),
                  ),
                  child: _buildIconContent(highlighted: highlighted),
                ),
              ),
            ),
          ),
          if (widget.showTooltipOnHover)
            Positioned(
              left: AppSpacing.sidebarItemSize + 16.0,
              child: IgnorePointer(
                child: AnimatedSlide(
                  offset: (_isHovered || _isFocused)
                      ? Offset.zero
                      : const Offset(-0.15, 0),
                  duration: tooltipDuration,
                  curve: AppMotion.standardCurve,
                  child: AnimatedOpacity(
                    opacity: (_isHovered || _isFocused) ? 1.0 : 0.0,
                    duration: tooltipDuration,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgSurfaceElevated,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: AppColors.sidebarBorder,
                          width: 1.0,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.sidebarShadow,
                            blurRadius: 16.0,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.section.navLabel,
                        style: AppTextStyles.labelSmall(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIconContent({required bool highlighted}) {
    final assetPath = widget.iconAssetPath;
    if (assetPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          assetPath,
          width: AppSpacing.sidebarItemIconSize,
          height: AppSpacing.sidebarItemIconSize,
          fit: BoxFit.cover,
        ),
      );
    }

    return switch (widget.section) {
      PortfolioSectionId.overview => Text(
          'TG',
          style: AppTextStyles.labelSmall(
            color: highlighted ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      PortfolioSectionId.capabilities => CustomPaint(
          size: const Size.square(20.0),
          painter: _ArchitectureLayersPainter(
            color: highlighted ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      PortfolioSectionId.contact => CustomPaint(
          size: const Size.square(20.0),
          painter: _ContactMailPainter(
            color: highlighted ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      PortfolioSectionId.nutrilens ||
      PortfolioSectionId.setpoint =>
        const SizedBox.shrink(),
    };
  }
}

class _ArchitectureLayersPainter extends CustomPainter {
  const _ArchitectureLayersPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final topDiamond = Path()
      ..moveTo(w * 0.5, h * 0.14)
      ..lineTo(w * 0.88, h * 0.36)
      ..lineTo(w * 0.5, h * 0.58)
      ..lineTo(w * 0.12, h * 0.36)
      ..close();
    canvas.drawPath(topDiamond, paint);

    final midLayer = Path()
      ..moveTo(w * 0.12, h * 0.54)
      ..lineTo(w * 0.5, h * 0.76)
      ..lineTo(w * 0.88, h * 0.54);
    canvas.drawPath(midLayer, paint);

    final bottomLayer = Path()
      ..moveTo(w * 0.12, h * 0.71)
      ..lineTo(w * 0.5, h * 0.93)
      ..lineTo(w * 0.88, h * 0.71);
    canvas.drawPath(bottomLayer, paint);
  }

  @override
  bool shouldRepaint(covariant _ArchitectureLayersPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _ContactMailPainter extends CustomPainter {
  const _ContactMailPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.12, h * 0.22, w * 0.76, h * 0.56),
      const Radius.circular(3.0),
    );
    canvas.drawRRect(rect, paint);

    final flap = Path()
      ..moveTo(w * 0.14, h * 0.28)
      ..lineTo(w * 0.50, h * 0.55)
      ..lineTo(w * 0.86, h * 0.28);
    canvas.drawPath(flap, paint);
  }

  @override
  bool shouldRepaint(covariant _ContactMailPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
