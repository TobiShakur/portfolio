import 'dart:async';

import 'package:flutter/material.dart';
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
  bool _disposed = false;

  Timer? _copyResetTimer;
  Timer? _toastTimer;

  PortfolioSectionId get activeSection => _activeSection;
  PortfolioSectionId? get hoveredSidebarSection => _hoveredSidebarSection;
  CopyEmailState get copyEmailState => _copyEmailState;
  String? get toastMessage => _toastMessage;

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

  void _onScroll() {
    if (_isProgrammaticScroll || !scrollController.hasClients) {
      return;
    }

    if (_isDesktop) {
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

    // Tablet / Mobile: determine active section from mounted section render boxes.
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

  Future<void> scrollToSection(
    PortfolioSectionId section, {
    required bool reduceMotion,
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
      final duration =
          reduceMotion ? Duration.zero : const Duration(milliseconds: 650);

      if (_isDesktop) {
        final targetOffset = (section.index * _sectionHeight)
            .clamp(0.0, scrollController.position.maxScrollExtent);
        if (reduceMotion) {
          scrollController.jumpTo(targetOffset);
        } else {
          await scrollController.animateTo(
            targetOffset,
            duration: duration,
            curve: Curves.easeInOutCubic,
          );
        }
      } else {
        final targetContext = sectionKeys[section]?.currentContext;
        if (targetContext != null) {
          await Scrollable.ensureVisible(
            targetContext,
            duration: duration,
            curve: Curves.easeInOutCubic,
            alignment: 0.0,
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
    scrollController.removeListener(_onScroll);
    if (_ownsScrollController) {
      scrollController.dispose();
    }
    super.dispose();
  }
}
