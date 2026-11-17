import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';
import 'package:portfolio/features/portfolio/domain/entities/project_showcase.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/portfolio_action_button.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/mockups/iphone_bezel_frame.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/mockups/preview_media_player.dart';

/// Front-facing interactive iPhone mockup with looping preview, hover/focus
/// backdrop blur, 1-line hover CTA pill, and live demo callback.
class InteractiveRightPhoneMockup extends StatefulWidget {
  const InteractiveRightPhoneMockup({
    required this.project,
    required this.width,
    required this.onOpenLiveDemo,
    super.key,
    this.showPersistentMobileCta = false,
    this.focusNode,
    this.previewAssetsOverride,
    this.controlledIndex,
    this.isPaused = false,
    this.onScreenChanged,
  });

  static const String ctaLabel = 'Open live demo';

  final ProjectShowcase project;
  final double width;
  final VoidCallback onOpenLiveDemo;
  final bool showPersistentMobileCta;
  final FocusNode? focusNode;
  final List<String>? previewAssetsOverride;
  final int? controlledIndex;
  final bool isPaused;
  final ValueChanged<int>? onScreenChanged;

  @override
  State<InteractiveRightPhoneMockup> createState() =>
      _InteractiveRightPhoneMockupState();
}

class _InteractiveRightPhoneMockupState
    extends State<InteractiveRightPhoneMockup> {
  FocusNode? _internalFocusNode;
  bool _isHovered = false;
  bool _isFocused = false;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  bool get _showOverlay => _isHovered || _isFocused;

  @override
  void dispose() {
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final enableHoverOverlay =
        MediaQuery.sizeOf(context).width >= AppSpacing.tablet;
    final showOverlay = enableHoverOverlay && _showOverlay;
    final duration = reduceMotion ? Duration.zero : AppMotion.hoverBlur;

    final mediaChild = PreviewMediaPlayer(
      project: widget.project,
      isBlurred: showOverlay,
      reduceMotion: reduceMotion,
      previewAssetsOverride: widget.previewAssetsOverride,
      controlledIndex: widget.controlledIndex,
      isPaused: widget.isPaused,
      onScreenChanged: widget.onScreenChanged,
    );

    final phone = RepaintBoundary(
      child: Semantics(
        button: true,
        label: '${widget.project.title}: ${InteractiveRightPhoneMockup.ctaLabel}',
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: enableHoverOverlay
              ? (_) {
                  if (!_isHovered) {
                    setState(() => _isHovered = true);
                  }
                }
              : null,
          onExit: enableHoverOverlay
              ? (_) {
                  if (_isHovered) {
                    setState(() => _isHovered = false);
                  }
                }
              : null,
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
                widget.onOpenLiveDemo();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: GestureDetector(
              onTap: widget.onOpenLiveDemo,
              child: IphoneBezelFrame(
                width: widget.width,
                ambientGlowColor: widget.project.accentColor,
                showAmbientGlow: false,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(end: showOverlay ? 1.0 : 0.0),
                  duration: duration,
                  curve: AppMotion.standardCurve,
                  child: mediaChild,
                  builder: (context, progress, child) {
                    final sigma = progress * 8.0;
                    final media = child ?? mediaChild;

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        if (sigma > 0.05)
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: sigma,
                              sigmaY: sigma,
                            ),
                            child: media,
                          )
                        else
                          media,
                        if (progress > 0.01) ...[
                          Opacity(
                            opacity: progress,
                            child:
                                const ColoredBox(color: AppColors.scrimHover),
                          ),
                          Center(
                            child: Opacity(
                              opacity: progress,
                              child: Transform.scale(
                                scale: 0.94 + (0.06 * progress),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 12.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: widget.project.accentColor,
                                        borderRadius: BorderRadius.circular(999.0),
                                        border: _isFocused
                                            ? Border.all(
                                                color: AppColors.textPrimary,
                                                width: 2.0,
                                              )
                                            : null,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x66000000),
                                            blurRadius: 18.0,
                                            offset: Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            InteractiveRightPhoneMockup.ctaLabel,
                                            maxLines: 1,
                                            style: AppTextStyles.buttonLabel(
                                              color: AppColors.ctaInkOnAccent,
                                            ),
                                          ),
                                          const SizedBox(width: 8.0),
                                          const Icon(
                                            Icons.north_east_rounded,
                                            size: 15.0,
                                            color: AppColors.ctaInkOnAccent,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (!widget.showPersistentMobileCta) {
      return phone;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        phone,
        const SizedBox(height: 16.0),
        PortfolioActionButton(
          label: InteractiveRightPhoneMockup.ctaLabel,
          variant: PortfolioButtonVariant.accentPill,
          accentColor: widget.project.accentColor,
          onPressed: widget.onOpenLiveDemo,
        ),
      ],
    );
  }
}
