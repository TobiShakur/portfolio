import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/core/theme/app_colors.dart';
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

  static const String ctaLabel = 'Launch Live Demo ↗';

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
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 220);

    final mediaChild = PreviewMediaPlayer(
      project: widget.project,
      isBlurred: _showOverlay,
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
          onEnter: (_) {
            if (!_isHovered) {
              setState(() => _isHovered = true);
            }
          },
          onExit: (_) {
            if (_isHovered) {
              setState(() => _isHovered = false);
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
                showAmbientGlow: true,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(end: _showOverlay ? 1.0 : 0.0),
                  duration: duration,
                  curve: Curves.easeOutCubic,
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
                                    horizontal: 10.0,
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14.0,
                                        vertical: 10.0,
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
                                      child: Text(
                                        InteractiveRightPhoneMockup.ctaLabel,
                                        maxLines: 1,
                                        style: AppTextStyles.buttonLabel(
                                          color: AppColors.ctaInkOnAccent,
                                        ),
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
