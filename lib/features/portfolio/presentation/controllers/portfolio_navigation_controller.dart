import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:portfolio/core/services/clipboard_service.dart';
import 'package:portfolio/core/services/external_link_launcher.dart';
import 'package:portfolio/core/services/url_validator.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_section_id.dart';

/// State of the inline email copy button.
@immutable
sealed class CopyEmailState {
  const CopyEmailState();
}

final class CopyEmailIdle extends CopyEmailState {
  const CopyEmailIdle();
}

final class CopyEmailCopied extends CopyEmailState {
  const CopyEmailCopied();
}

final class CopyEmailError extends CopyEmailState {
  const CopyEmailError();
}

/// Manages active section tracking, smooth snap scrolling, email copy state,
/// and hardened external link navigation.
final class PortfolioNavigationController extends ChangeNotifier {
  PortfolioNavigationController({
    required this._linkLauncher,
    required this._clipboardService,
    ScrollController? scrollController,
  })  : _ownsScrollController = scrollController == null,
        scrollController = scrollController ?? ScrollController() {
    this.scrollController.addListener(_onScroll);
  }

  final ExternalLinkLauncher _linkLauncher;
  final ClipboardService _clipboardService;
  final bool _ownsScrollController;
  final ScrollController scrollController;

  final Map<PortfolioSectionId, GlobalKey> sectionKeys = {
    for (final section in PortfolioSectionId.values) section: GlobalKey(),
  };

  PortfolioSectionId _activeSection = PortfolioSectionId.overview;
  PortfolioSectionId? _hoveredSidebarSection;
  CopyEmailState _copyEmailState = const CopyEmailIdle();
  String? _toastMessage;

  double _sectionHeight = 900.0;
  double _viewportHeight = 900.0;
  bool _isDesktop = true;
  bool _isProgrammaticScroll = false;
  bool _isSnapAnimating = false;
  bool _disposed = false;
  bool _isBackgroundMotionPaused = false;

  bool get isBackgroundMotionPaused => _isBackgroundMotionPaused;

  void toggleBackgroundMotionPaused() {
    if (_disposed) {
      return;
    }
    _isBackgroundMotionPaused = !_isBackgroundMotionPaused;
    notifyListeners();
  }

  Timer? _copyResetTimer;
  Timer? _toastTimer;
  Timer? _snapCooldownTimer;

  PortfolioSectionId get activeSection => _activeSection;
  PortfolioSectionId? get hoveredSidebarSection => _hoveredSidebarSection;
  CopyEmailState get copyEmailState => _copyEmailState;
  String? get toastMessage => _toastMessage;
  bool get isSnapAnimating => _isSnapAnimating;

  static double effectiveSectionHeight(double viewportHeight) {
    return viewportHeight >= AppSpacing.minDesktopSectionHeight
        ? viewportHeight
        : AppSpacing.minDesktopSectionHeight;
  }

  void updateViewportMetrics({
    required double viewportHeight,
    required bool isDesktop,
  }) {
    _viewportHeight = viewportHeight;
    _sectionHeight = effectiveSectionHeight(viewportHeight);
    _isDesktop = isDesktop;
  }

  void setHoveredSidebarSection(PortfolioSectionId? section) {
    _hoveredSidebarSection = section;
  }

  /// Resolves the scroll offset of [section] via its mounted RenderObject,
  /// falling back to logical section spacing when detached (e.g. unit tests).
  double? resolveSectionOffset(PortfolioSectionId section) {
    if (!scrollController.hasClients) {
      return null;
    }
    final ctx = sectionKeys[section]?.currentContext;
    if (ctx != null) {
      final renderObject = ctx.findRenderObject();
      if (renderObject is RenderBox && renderObject.hasSize) {
        final viewport = RenderAbstractViewport.maybeOf(renderObject);
        if (viewport != null) {
          final revealed = viewport.getOffsetToReveal(renderObject, 0.0).offset;
          return revealed.clamp(0.0, scrollController.position.maxScrollExtent);
        }
      }
    }
    return (section.index * _sectionHeight)
        .clamp(0.0, scrollController.position.maxScrollExtent);
  }

  /// True when [section] sits within ±1.2 viewport heights of the current scroll.
  bool isSectionNearViewport(PortfolioSectionId section) {
    if (!scrollController.hasClients) {
      return (section.index - _activeSection.index).abs() <= 1;
    }
    final ctx = sectionKeys[section]?.currentContext;
    final currentOffset = scrollController.offset;
    final rangeMin = currentOffset - (_viewportHeight * 1.2);
    final rangeMax = currentOffset + (_viewportHeight * 1.2);

    if (ctx != null) {
      final renderObject = ctx.findRenderObject();
      if (renderObject is RenderBox && renderObject.hasSize) {
        final viewport = RenderAbstractViewport.maybeOf(renderObject);
        if (viewport != null) {
          final top = viewport.getOffsetToReveal(renderObject, 0.0).offset;
          final bottom = top + renderObject.size.height;
          return bottom >= rangeMin && top <= rangeMax;
        }
      }
    }
    return (section.index - _activeSection.index).abs() <= 1;
  }

  void _onScroll() {
    if (_isProgrammaticScroll || !scrollController.hasClients) {
      return;
    }

    final hasMountedSections = sectionKeys.values.any(
      (key) => key.currentContext?.findRenderObject() is RenderBox,
    );

    if (!hasMountedSections) {
      final offset = scrollController.offset;
      final index = ((offset + _sectionHeight * 0.45) / _sectionHeight)
          .floor()
          .clamp(0, PortfolioSectionId.values.length - 1);
      final nextSection = PortfolioSectionId.values[index];
      if (nextSection != _activeSection) {
        _activeSection = nextSection;
        notifyListeners();
      }
      return;
    }

    // Activate final stop when scrolled to the bottom of the page.
    if (scrollController.position.maxScrollExtent > 0 &&
        scrollController.offset >=
            scrollController.position.maxScrollExtent - 24.0) {
      const last = PortfolioSectionId.contact;
      if (_activeSection != last) {
        _activeSection = last;
        notifyListeners();
      }
      return;
    }

    final threshold = _viewportHeight * 0.35;
    var candidate = PortfolioSectionId.overview;
    for (final section in PortfolioSectionId.values) {
      final ctx = sectionKeys[section]?.currentContext;
      if (ctx == null) {
        continue;
      }
      final renderObject = ctx.findRenderObject();
      if (renderObject is RenderBox && renderObject.hasSize) {
        final top = renderObject.localToGlobal(Offset.zero).dy;
        if (top <= threshold) {
          candidate = section;
        }
      }
    }

    if (candidate != _activeSection) {
      _activeSection = candidate;
      notifyListeners();
    }
  }

  /// Snaps one section forward/backward on desktop wheel without hijacking tall sections.
  bool handleDesktopWheelScroll({
    required double deltaY,
    required bool reduceMotion,
  }) {
    if (!_isDesktop ||
        reduceMotion ||
        _isSnapAnimating ||
        !scrollController.hasClients) {
      return false;
    }
    if (deltaY.abs() < 18.0) {
      return false;
    }

    final activeKey = sectionKeys[_activeSection];
    final renderObject = activeKey?.currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      final top = renderObject.localToGlobal(Offset.zero).dy;
      final bottom = top + renderObject.size.height;
      // Allow native scrolling inside sections taller than the current viewport.
      if (deltaY > 0 && bottom > _viewportHeight + 16.0) {
        return false;
      }
      if (deltaY < 0 && top < -16.0) {
        return false;
      }
    }

    final direction = deltaY > 0 ? 1 : -1;
    final nextIndex = _activeSection.index + direction;
    if (nextIndex < 0 || nextIndex >= PortfolioSectionId.values.length) {
      return false;
    }

    _isSnapAnimating = true;
    _snapCooldownTimer?.cancel();
    _snapCooldownTimer = Timer(const Duration(milliseconds: 520), () {
      _isSnapAnimating = false;
    });

    unawaited(
      scrollToSection(
        PortfolioSectionId.values[nextIndex],
        reduceMotion: false,
        durationOverride: const Duration(milliseconds: 560),
      ),
    );
    return true;
  }

  /// Steps relative to the current active section (used by PageUp/PageDown keys).
  Future<void> stepSection(
    int delta, {
    required bool reduceMotion,
  }) async {
    final targetIndex =
        (_activeSection.index + delta).clamp(0, PortfolioSectionId.values.length - 1);
    await scrollToSection(
      PortfolioSectionId.values[targetIndex],
      reduceMotion: reduceMotion,
    );
  }

  Future<void> scrollToSection(
    PortfolioSectionId section, {
    required bool reduceMotion,
    Duration? durationOverride,
  }) async {
    if (_activeSection != section) {
      _activeSection = section;
      notifyListeners();
    }

    if (!scrollController.hasClients) {
      return;
    }

    _isProgrammaticScroll = true;
    try {
      final duration = reduceMotion
          ? Duration.zero
          : (durationOverride ?? const Duration(milliseconds: 620));

      final targetOffset = resolveSectionOffset(section);
      if (targetOffset != null) {
        if (reduceMotion) {
          scrollController.jumpTo(targetOffset);
        } else {
          await scrollController.animateTo(
            targetOffset,
            duration: duration,
            curve: AppMotion.standardCurve,
          );
        }
      }
    } finally {
      _isProgrammaticScroll = false;
    }
  }

  Future<void> copyEmail(String email) async {
    _copyResetTimer?.cancel();
    final result = await _clipboardService.copyText(email);
    if (_disposed) {
      return;
    }

    switch (result) {
      case ClipboardSuccess():
        _copyEmailState = const CopyEmailCopied();
        notifyListeners();
        _copyResetTimer = Timer(const Duration(milliseconds: 2200), () {
          if (_disposed) {
            return;
          }
          _copyEmailState = const CopyEmailIdle();
          notifyListeners();
        });
      case ClipboardFailure():
        _copyEmailState = const CopyEmailError();
        _showToast('Could not copy email');
        _copyResetTimer = Timer(const Duration(milliseconds: 2200), () {
          if (_disposed) {
            return;
          }
          _copyEmailState = const CopyEmailIdle();
          notifyListeners();
        });
    }
  }

  Future<void> openExternalUrl(String url) async {
    final result = await _linkLauncher.openExternal(url);
    if (_disposed) {
      return;
    }

    switch (result) {
      case LinkLaunchSuccess():
        return;
      case LinkLaunchFailure():
        if (UrlValidator.parseAllowedUri(url) != null) {
          await _clipboardService.copyText(url);
          if (_disposed) {
            return;
          }
          _showToast('Could not open link — URL copied to clipboard');
        } else {
          _showToast('Could not open external link');
        }
      case LinkLaunchRejected():
        _showToast('Blocked invalid external URL');
    }
  }

  void _showToast(String message) {
    _toastTimer?.cancel();
    _toastMessage = message;
    notifyListeners();
    _toastTimer = Timer(const Duration(seconds: 3), () {
      if (_disposed) {
        return;
      }
      _toastMessage = null;
      notifyListeners();
    });
  }

  void dismissToast() {
    _toastTimer?.cancel();
    if (_toastMessage == null) {
      return;
    }
    _toastMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _copyResetTimer?.cancel();
    _toastTimer?.cancel();
    _snapCooldownTimer?.cancel();
    scrollController.removeListener(_onScroll);
    if (_ownsScrollController) {
      scrollController.dispose();
    }
    super.dispose();
  }
}
