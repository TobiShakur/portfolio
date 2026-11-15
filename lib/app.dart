import 'dart:async';

import 'package:flutter/material.dart';
import 'package:portfolio/core/services/clipboard_service.dart';
import 'package:portfolio/core/services/concept_url_sync_service.dart';
import 'package:portfolio/core/services/external_link_launcher.dart';
import 'package:portfolio/core/services/perf_telemetry_service.dart';
import 'package:portfolio/core/services/portfolio_ready_notifier.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/features/portfolio/presentation/controllers/portfolio_concept_controller.dart';
import 'package:portfolio/features/portfolio/presentation/controllers/portfolio_navigation_controller.dart';
import 'package:portfolio/features/portfolio/presentation/screens/portfolio_page.dart';

/// Root MaterialApp with constructor-injected platform services for testability.
class PortfolioApp extends StatefulWidget {
  const PortfolioApp({
    super.key,
    this.linkLauncher = const UrlLauncherExternalLinkLauncher(),
    this.clipboardService = const FlutterClipboardService(),
    this.controller,
    this.conceptController,
    this.conceptUrlSyncService,
    this.perfTelemetryService,
  });

  final ExternalLinkLauncher linkLauncher;
  final ClipboardService clipboardService;
  final PortfolioNavigationController? controller;
  final PortfolioConceptController? conceptController;
  final ConceptUrlSyncService? conceptUrlSyncService;
  final PerfTelemetryService? perfTelemetryService;

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  late final PortfolioNavigationController _controller;
  late final PortfolioConceptController _conceptController;
  late final bool _ownsController;
  late final bool _ownsConceptController;
  bool _warmupStarted = false;
  Timer? _warmupTimeoutTimer;

  static const List<String> _initialViewportImageAssets = [
    'assets/icons/nutrilens_icon.webp',
    'assets/icons/setpoint_icon.webp',
    'assets/images/nutrilens_dashboard.webp',
    'assets/images/setpoint_map.webp',
  ];

  static const List<String> _deferredProjectImageAssets = [
    'assets/images/nutrilens_scan.webp',
    'assets/images/nutrilens_analysis.webp',
    'assets/images/nutrilens_pantry.webp',
    'assets/images/setpoint_feed.webp',
    'assets/images/setpoint_filters.webp',
    'assets/images/setpoint_match_doubles.webp',
  ];

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ??
        PortfolioNavigationController(
          linkLauncher: widget.linkLauncher,
          clipboardService: widget.clipboardService,
        );

    _ownsConceptController = widget.conceptController == null;
    _conceptController = widget.conceptController ??
        PortfolioConceptController(
          urlSyncService: widget.conceptUrlSyncService,
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_warmupStarted) {
      return;
    }
    _warmupStarted = true;
    _awaitInitialAssetsAndNotify();
  }

  Future<void> _awaitInitialAssetsAndNotify() async {
    final readyCompleter = Completer<void>();

    void finishWarmup() {
      _warmupTimeoutTimer?.cancel();
      _warmupTimeoutTimer = null;
      if (!readyCompleter.isCompleted) {
        readyCompleter.complete();
      }
    }

    _warmupTimeoutTimer =
        Timer(const Duration(milliseconds: 1500), finishWarmup);

    final firstFrameCompleter = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!firstFrameCompleter.isCompleted) {
        firstFrameCompleter.complete();
      }
    });

    final imageFutures = <Future<void>>[
      for (final asset in _initialViewportImageAssets)
        precacheImage(AssetImage(asset), context).catchError((_) {}),
    ];

    unawaited(
      Future.wait<void>([
        firstFrameCompleter.future,
        ...imageFutures,
      ]).then((_) => finishWarmup(), onError: (_) => finishWarmup()),
    );

    await readyCompleter.future;

    if (!mounted) {
      return;
    }
    notifyPortfolioReady();
    _precacheDeferredProjectImages();
  }

  void _precacheDeferredProjectImages() {
    for (final asset in _deferredProjectImageAssets) {
      unawaited(precacheImage(AssetImage(asset), context).catchError((_) {}));
    }
  }

  @override
  void dispose() {
    _warmupTimeoutTimer?.cancel();
    if (_ownsController) {
      _controller.dispose();
    }
    if (_ownsConceptController) {
      _conceptController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tobías Gutiérrez — Mobile Software Engineer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: PortfolioPage(
        controller: _controller,
        conceptController: _conceptController,
        perfTelemetryService: widget.perfTelemetryService,
      ),
    );
  }
}
