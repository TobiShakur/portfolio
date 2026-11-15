import 'package:flutter/foundation.dart';
import 'package:portfolio/core/services/concept_url_sync_service.dart';
import 'package:portfolio/core/services/concept_url_sync_service_platform.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_concept_id.dart';

/// Holds active design concept presets (unified or mixed Hero/Work) + backdrop pause.
final class PortfolioConceptController extends ChangeNotifier {
  PortfolioConceptController({
    ConceptUrlSyncService? urlSyncService,
    PortfolioConceptId? initialHeroConcept,
    PortfolioConceptId? initialWorkConcept,
  }) : _urlSyncService = urlSyncService ?? PlatformConceptUrlSyncService() {
    final parsed = _urlSyncService.readInitialSelection();
    _heroConcept = initialHeroConcept ??
        parsed.heroConcept ??
        PortfolioConceptId.editorialWall;
    _workConcept = initialWorkConcept ??
        parsed.workConcept ??
        PortfolioConceptId.editorialWall;
  }

  final ConceptUrlSyncService _urlSyncService;

  late PortfolioConceptId _heroConcept;
  late PortfolioConceptId _workConcept;
  bool _isMixExpanded = false;
  bool _isBackgroundMotionPaused = false;

  PortfolioConceptId get heroConcept => _heroConcept;
  PortfolioConceptId get workConcept => _workConcept;
  bool get isMixExpanded => _isMixExpanded;
  bool get isBackgroundMotionPaused => _isBackgroundMotionPaused;
  bool get isMixed => _heroConcept != _workConcept;

  void selectUnifiedConcept(PortfolioConceptId id) {
    final changed = _heroConcept != id || _workConcept != id || _isMixExpanded;
    _heroConcept = id;
    _workConcept = id;
    _isMixExpanded = false;
    _urlSyncService.syncConcepts(hero: _heroConcept, work: _workConcept);
    if (changed) {
      notifyListeners();
    }
  }

  void setHeroConcept(PortfolioConceptId id) {
    if (_heroConcept == id) {
      return;
    }
    _heroConcept = id;
    _urlSyncService.syncConcepts(hero: _heroConcept, work: _workConcept);
    notifyListeners();
  }

  void setWorkConcept(PortfolioConceptId id) {
    if (_workConcept == id) {
      return;
    }
    _workConcept = id;
    _urlSyncService.syncConcepts(hero: _heroConcept, work: _workConcept);
    notifyListeners();
  }

  void syncMatchingToHero() {
    selectUnifiedConcept(_heroConcept);
  }

  void toggleMixExpanded() {
    _isMixExpanded = !_isMixExpanded;
    notifyListeners();
  }

  void closeMixExpanded() {
    if (!_isMixExpanded) {
      return;
    }
    _isMixExpanded = false;
    notifyListeners();
  }

  void toggleBackgroundMotionPaused() {
    _isBackgroundMotionPaused = !_isBackgroundMotionPaused;
    notifyListeners();
  }
}
