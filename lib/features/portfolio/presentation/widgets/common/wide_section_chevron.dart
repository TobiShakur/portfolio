import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';

/// Direction of [WideSectionChevron].
enum WideSectionChevronDirection { down, up }

/// Wide low-profile section navigation chevron (`56×12px` stroke inside an `80×44px`
/// accessible hit target) with smooth hover shift and WCAG 2.2 focus ring.
class WideSectionChevron extends StatefulWidget {
  const WideSectionChevron({
    required this.onPressed,
    required this.semanticLabel,
    super.key,
    this.direction = WideSectionChevronDirection.down,
    this.accentColor = AppColors.accentEngineering,
    this.focusNode,
  });

  final VoidCallback onPressed;
  final String semanticLabel;
  final WideSectionChevronDirection direction;
  final Color accentColor;
  final FocusNode? focusNode;

  @override
  State<WideSectionChevron> createState() => _WideSectionChevronState();
}

class _WideSectionChevronState extends State<WideSectionChevron> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final active = _hovered || _focused;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final dyShift = active && !reduceMotion
        ? (widget.direction == WideSectionChevronDirection.down ? 3.0 : -3.0)
        : 0.0;
    final strokeColor = active ? AppColors.textPrimary : AppColors.textMuted;

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: Tooltip(
        message: widget.semanticLabel,
        waitDuration: const Duration(milliseconds: 350),
        child: FocusableActionDetector(
          focusNode: widget.focusNode,
          mouseCursor: SystemMouseCursors.click,
          onShowHoverHighlight: (v) => setState(() => _hovered = v),
          onShowFocusHighlight: (v) => setState(() => _focused = v),
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                widget.onPressed();
                return null;
              },
            ),
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onPressed,
            child: Container(
              width: 80.0,
              height: 44.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: _focused
                    ? Border.all(color: widget.accentColor, width: 2.0)
                    : null,
              ),
              child: AnimatedContainer(
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                transform: Matrix4.translationValues(0.0, dyShift, 0.0),
                child: CustomPaint(
                  size: const Size(56.0, 12.0),
                  painter: _WideChevronPainter(
                    color: strokeColor,
                    direction: widget.direction,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WideChevronPainter extends CustomPainter {
  const _WideChevronPainter({
    required this.color,
    required this.direction,
  });

  final Color color;
  final WideSectionChevronDirection direction;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    if (direction == WideSectionChevronDirection.down) {
      path
        ..moveTo(2.0, 2.0)
        ..lineTo(28.0, 10.0)
        ..lineTo(54.0, 2.0);
    } else {
      path
        ..moveTo(2.0, 10.0)
        ..lineTo(28.0, 2.0)
        ..lineTo(54.0, 10.0);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WideChevronPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.direction != direction;
  }
}
