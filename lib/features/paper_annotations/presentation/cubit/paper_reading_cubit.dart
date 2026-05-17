import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/my_logger.dart';
import '../../../home/domain/entities/paper_entity.dart';
import '../../../papers/domain/usecases/get_paper_by_id_usecase.dart';
import '../../domain/entites/highlight_entity.dart';
import '../../domain/entites/highlight_note_params.dart';
import '../../domain/entites/paper_highlights_params.dart';
import '../../domain/usecases/add_highlight_note_usecase.dart';
import '../../domain/usecases/delete_highlight_note_usecase.dart';
import '../../domain/usecases/delete_highlight_usecase.dart';
import '../../domain/usecases/get_annotated_highlights_usecase.dart';
import '../../domain/usecases/get_highlights_usecase.dart';
import '../../domain/usecases/save_highlight_usecase.dart';
import '../../domain/usecases/update_highlight_note_usecase.dart';
import '../../domain/usecases/update_highlight_usecase.dart';
import '../widgets/annotation_webview_platform.dart';
import 'paper_reading_state.dart';

class PaperReadingCubit extends Cubit<PaperReadingState> {
  final GetPaperByIdUseCase getPaperByIdUseCase;
  final GetHighlightsUseCase getHighlightsUseCase;
  final GetAnnotatedHighlightsUseCase getAnnotatedHighlightsUseCase;
  final SaveHighlightUseCase saveHighlightUseCase;
  final UpdateHighlightUseCase updateHighlightUseCase;
  final DeleteHighlightUseCase deleteHighlightUseCase;
  final AddHighlightNoteUseCase addHighlightNoteUseCase;
  final UpdateHighlightNoteUseCase updateHighlightNoteUseCase;
  final DeleteHighlightNoteUseCase deleteHighlightNoteUseCase;

  static const _uuid = Uuid();

  // Track annotated highlights for pagination
  List<Highlight> _annotatedHighlights = [];
  String? _currentAnnotationPaperId;

  String _normalizeCssColor(String color) {
    final clean = color.replaceAll('#', '').toUpperCase();
    if (clean.length == 6) return '#$clean';
    if (clean.length == 8) return '#${clean.substring(2)}';
    return '#FFE082';
  }

  PaperReadingCubit({
    required this.getPaperByIdUseCase,
    required this.getHighlightsUseCase,
    required this.getAnnotatedHighlightsUseCase,
    required this.saveHighlightUseCase,
    required this.updateHighlightUseCase,
    required this.deleteHighlightUseCase,
    required this.addHighlightNoteUseCase,
    required this.updateHighlightNoteUseCase,
    required this.deleteHighlightNoteUseCase,
  }) : super(const PaperReadingInitial());

  Future<void> loadPaper(PaperEntity paper) async {
    MyLogger.info(
      '[PaperReadingCubit] Loading paper: ${paper.id} - ${paper.title}',
    );
    emit(const PaperReadingLoading());

    // Load paper content first
    final paperResult = await getPaperByIdUseCase(paper.id);

    paperResult.fold(
      (failure) {
        MyLogger.error('[PaperReadingCubit] Failed to load paper: $failure');
        emit(const PaperReadingError(message: 'Failed to load paper content.'));
      },
      (fullPaper) {
        MyLogger.info(
          '[PaperReadingCubit] Paper loaded, content length: ${fullPaper.content.length}',
        );
        final html = fullPaper.content.join('\n');

        // Emit loaded state immediately with paper content (empty highlights for now)
        MyLogger.info(
          '[PaperReadingCubit] Emitting PaperReadingLoaded state to render content',
        );
        emit(
          PaperReadingLoaded(
            paper: paper,
            paperHtml: html,
            highlights: const [],
          ),
        );

        _loadHighlights(paper.id);
      },
    );
  }

  Future<void> _loadHighlights(String paperId) async {
    MyLogger.info('[PaperReadingCubit] Loading highlights for paper: $paperId');

    final highlightsResult = await getHighlightsUseCase(paperId);

    highlightsResult.fold(
      (failure) {
        MyLogger.warning(
          '[PaperReadingCubit] Failed to load highlights: $failure - continuing with empty highlights',
        );
        // Don't update state, just log the failure
      },
      (highlights) {
        MyLogger.info(
          '[PaperReadingCubit] Loaded ${highlights.length} highlights, updating state',
        );
        final currentState = state;
        if (currentState is PaperReadingLoaded) {
          emit(currentState.copyWith(highlights: highlights));
        }
      },
    );
  }

  Future<List<Highlight>> loadAnnotatedHighlights(String paperId) async {
    final currentState = state;
    if (currentState is PaperReadingLoaded) {
      // Reset pagination for new paper
      if (_currentAnnotationPaperId != paperId) {
        _annotatedHighlights = [];
        _currentAnnotationPaperId = paperId;
        emit(
          currentState.copyWith(
            annotatedHighlightPage: 1,
            annotatedHighlightHasMore: true,
            annotatedHighlightLoading: true,
          ),
        );
      }
    }

    final result = await getAnnotatedHighlightsUseCase(
      PaperHighlightsParams(paperId: paperId, page: 1, limit: 20),
    );

    return result.fold(
      (failure) {
        MyLogger.warning(
          '[PaperReadingCubit] Failed to load annotated highlights: $failure',
        );
        if (currentState is PaperReadingLoaded) {
          emit(currentState.copyWith(annotatedHighlightLoading: false));
        }
        return _annotatedHighlights.isEmpty
            ? (currentState is PaperReadingLoaded
                  ? currentState.highlights
                        .where(
                          (highlight) => highlight.note?.isNotEmpty == true,
                        )
                        .toList()
                  : <Highlight>[])
            : _annotatedHighlights;
      },
      (highlights) {
        _annotatedHighlights = highlights;
        if (currentState is PaperReadingLoaded) {
          emit(
            currentState.copyWith(
              annotatedHighlightPage: 1,
              annotatedHighlightHasMore: highlights.length >= 20,
              annotatedHighlightLoading: false,
            ),
          );
        }
        return highlights;
      },
    );
  }

  Future<void> loadMoreAnnotatedHighlights(String paperId) async {
    final currentState = state;
    if (currentState is! PaperReadingLoaded ||
        !currentState.annotatedHighlightHasMore ||
        currentState.annotatedHighlightLoading) {
      return;
    }

    final nextPage = currentState.annotatedHighlightPage + 1;
    emit(currentState.copyWith(annotatedHighlightLoading: true));

    final result = await getAnnotatedHighlightsUseCase(
      PaperHighlightsParams(paperId: paperId, page: nextPage, limit: 20),
    );

    result.fold(
      (failure) {
        MyLogger.error(
          '[PaperReadingCubit] Failed to load more highlights: $failure',
        );
        emit(currentState.copyWith(annotatedHighlightLoading: false));
      },
      (highlights) {
        _annotatedHighlights.addAll(highlights);
        emit(
          currentState.copyWith(
            annotatedHighlightPage: nextPage,
            annotatedHighlightHasMore: highlights.length >= 20,
            annotatedHighlightLoading: false,
          ),
        );
      },
    );
  }

  void onTextSelected(AnnotationSelectionData selection) {
    final currentState = state;
    if (currentState is! PaperReadingLoaded) return;

    emit(currentState.copyWith(currentSelection: selection));
  }

  void onSelectionCleared() {
    final currentState = state;
    if (currentState is! PaperReadingLoaded) return;

    emit(currentState.copyWith(clearSelection: true));
  }

  Future<void> addHighlight({
    String? highlightId,
    required String selectedText,
    required String color,
    String? note,
    String? xpathStart,
    String? xpathEnd,
    int? startOffset,
    int? endOffset,
    String? plainText,
    String? htmlContent,
    String? contextBefore,
    String? contextAfter,
    String? firstWord,
    String? lastWord,
    int? selectedWordCount,
    int? selectedCharLength,
  }) async {
    final currentState = state;
    if (currentState is! PaperReadingLoaded) return;

    final normalizedColor = _normalizeCssColor(color);

    final highlight = Highlight(
      id: highlightId ?? _uuid.v4(),
      paperId: currentState.paper.id,
      selectedText: selectedText,
      note: note,
      color: normalizedColor,
      createdAt: DateTime.now(),
      xpathStart: xpathStart,
      xpathEnd: xpathEnd,
      startOffset: startOffset,
      endOffset: endOffset,
      plainText: plainText,
      htmlContent: htmlContent,
      contextBefore: contextBefore,
      contextAfter: contextAfter,
      firstWord: firstWord,
      lastWord: lastWord,
      selectedWordCount: selectedWordCount,
      selectedCharLength: selectedCharLength,
    );

    // Optimistic update
    emit(
      currentState.copyWith(
        highlights: [...currentState.highlights, highlight],
        clearSelection: true,
      ),
    );

    // Save to repository
    final result = await saveHighlightUseCase(highlight);
    result.fold(
      (failure) {
        MyLogger.error(
          '[PaperReadingCubit] Failed to save highlight: $failure',
        );
        // Rollback on failure
        final newState = state;
        if (newState is PaperReadingLoaded) {
          emit(
            newState.copyWith(
              highlights: newState.highlights
                  .where((h) => h.id != highlight.id)
                  .toList(),
            ),
          );
        }
      },
      (savedHighlight) {
        final latestState = state;
        if (latestState is PaperReadingLoaded) {
          final replacedHighlights = latestState.highlights
              .map(
                (currentHighlight) => currentHighlight.id == highlight.id
                    ? savedHighlight
                    : currentHighlight,
              )
              .toList();
          emit(latestState.copyWith(highlights: replacedHighlights));
        }

        MyLogger.info(
          '[PaperReadingCubit] Highlight saved: ${savedHighlight.id}',
        );
      },
    );
  }

  Future<void> updateHighlightColor(String highlightId, String newColor) async {
    final currentState = state;
    if (currentState is! PaperReadingLoaded) return;

    final highlightIndex = currentState.highlights.indexWhere(
      (h) => h.id == highlightId,
    );
    if (highlightIndex == -1) return;

    final oldHighlight = currentState.highlights[highlightIndex];
    final normalizedColor = _normalizeCssColor(newColor);
    final updatedHighlight = oldHighlight.copyWithColor(normalizedColor);

    // Optimistic update
    final updatedHighlights = List<Highlight>.from(currentState.highlights);
    updatedHighlights[highlightIndex] = updatedHighlight;
    emit(currentState.copyWith(highlights: updatedHighlights));

    // Save to repository
    final result = await updateHighlightUseCase(updatedHighlight);
    result.fold(
      (failure) {
        MyLogger.error(
          '[PaperReadingCubit] Failed to update highlight color: $failure',
        );
        // Rollback
        final newState = state;
        if (newState is PaperReadingLoaded) {
          final rollbackHighlights = List<Highlight>.from(newState.highlights);
          rollbackHighlights[highlightIndex] = oldHighlight;
          emit(newState.copyWith(highlights: rollbackHighlights));
        }
      },
      (saved) {
        MyLogger.info('[PaperReadingCubit] Highlight color updated');
      },
    );
  }

  Future<void> updateHighlightNote(String highlightId, String note) async {
    final currentState = state;
    if (currentState is! PaperReadingLoaded) return;

    final highlightIndex = currentState.highlights.indexWhere(
      (h) => h.id == highlightId,
    );
    if (highlightIndex == -1) return;

    final oldHighlight = currentState.highlights[highlightIndex];
    final updatedHighlight = oldHighlight.copyWithNote(note);

    // Optimistic update
    final updatedHighlights = List<Highlight>.from(currentState.highlights);
    updatedHighlights[highlightIndex] = updatedHighlight;
    emit(currentState.copyWith(highlights: updatedHighlights));

    final params = HighlightNoteParams(
      paperId: currentState.paper.id,
      highlightId: highlightId,
      note: note,
    );

    final result = oldHighlight.note?.isNotEmpty == true
        ? await updateHighlightNoteUseCase(params)
        : await addHighlightNoteUseCase(params);
    result.fold(
      (failure) {
        MyLogger.error(
          '[PaperReadingCubit] Failed to update highlight note: $failure',
        );
        // Rollback
        final newState = state;
        if (newState is PaperReadingLoaded) {
          final rollbackHighlights = List<Highlight>.from(newState.highlights);
          rollbackHighlights[highlightIndex] = oldHighlight;
          emit(newState.copyWith(highlights: rollbackHighlights));
        }
      },
      (saved) {
        MyLogger.info('[PaperReadingCubit] Highlight note updated');
      },
    );
  }

  Future<void> deleteHighlightNote(String highlightId) async {
    final currentState = state;
    if (currentState is! PaperReadingLoaded) return;

    final highlightIndex = currentState.highlights.indexWhere(
      (h) => h.id == highlightId,
    );
    if (highlightIndex == -1) return;

    final oldHighlight = currentState.highlights[highlightIndex];
    final updatedHighlight = oldHighlight.copyWith(note: '');

    final updatedHighlights = List<Highlight>.from(currentState.highlights);
    updatedHighlights[highlightIndex] = updatedHighlight;
    emit(currentState.copyWith(highlights: updatedHighlights));

    final result = await deleteHighlightNoteUseCase(
      HighlightNoteParams(
        paperId: currentState.paper.id,
        highlightId: highlightId,
        note: '',
      ),
    );

    result.fold(
      (failure) {
        MyLogger.error(
          '[PaperReadingCubit] Failed to delete highlight note: $failure',
        );
        final newState = state;
        if (newState is PaperReadingLoaded) {
          final rollbackHighlights = List<Highlight>.from(newState.highlights);
          rollbackHighlights[highlightIndex] = oldHighlight;
          emit(newState.copyWith(highlights: rollbackHighlights));
        }
      },
      (_) {
        MyLogger.info('[PaperReadingCubit] Highlight note deleted');
      },
    );
  }

  Future<void> deleteHighlight(String highlightId) async {
    final currentState = state;
    if (currentState is! PaperReadingLoaded) return;

    final oldHighlights = currentState.highlights;

    // Optimistic update
    final updatedHighlights = oldHighlights
        .where((h) => h.id != highlightId)
        .toList();
    emit(currentState.copyWith(highlights: updatedHighlights));

    // Delete from repository
    final result = await deleteHighlightUseCase(highlightId);
    result.fold(
      (failure) {
        MyLogger.error(
          '[PaperReadingCubit] Failed to delete highlight: $failure',
        );
        // Rollback
        final newState = state;
        if (newState is PaperReadingLoaded) {
          emit(newState.copyWith(highlights: [...oldHighlights]));
        }
      },
      (_) {
        MyLogger.info('[PaperReadingCubit] Highlight deleted: $highlightId');
      },
    );
  }

  void updateScrollProgress(double progress) {
    final currentState = state;
    if (currentState is! PaperReadingLoaded) return;

    emit(currentState.copyWith(scrollProgress: progress));
  }

  void updateFontScale(double scale) {
    final currentState = state;
    if (currentState is! PaperReadingLoaded) return;

    emit(currentState.copyWith(fontScale: scale));
  }

  void openSearch() {
    final currentState = state;
    if (currentState is! PaperReadingLoaded) return;

    emit(currentState.copyWith(searchOpen: true, menuOpen: false));
  }

  void closeSearch() {
    final currentState = state;
    if (currentState is! PaperReadingLoaded) return;

    emit(
      currentState.copyWith(
        searchOpen: false,
        searchQuery: '',
        searchCurrent: 0,
        searchTotal: 0,
      ),
    );
  }

  void updateSearchResults(String query, int current, int total) {
    final currentState = state;
    if (currentState is! PaperReadingLoaded) return;

    emit(
      currentState.copyWith(
        searchQuery: query,
        searchCurrent: current,
        searchTotal: total,
      ),
    );
  }

  void toggleMenu() {
    final currentState = state;
    if (currentState is! PaperReadingLoaded) return;

    emit(currentState.copyWith(menuOpen: !currentState.menuOpen));
  }

  void closeMenu() {
    final currentState = state;
    if (currentState is! PaperReadingLoaded) return;

    emit(currentState.copyWith(menuOpen: false));
  }
}
