import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirath/core/utils/my_logger.dart';
import 'package:mirath/features/paper_annotations/presentation/widgets/annotation_webview.dart';
import 'package:uuid/uuid.dart';
import '../../../home/domain/entities/paper_entity.dart';
import '../../../papers/domain/usecases/get_paper_by_id_usecase.dart';
import '../../domain/entites/highlight_entity.dart';
import '../../domain/usecases/delete_highlight_usecase.dart';
import '../../domain/usecases/get_highlights_usecase.dart';
import '../../domain/usecases/save_highlight_usecase.dart';
import '../../domain/usecases/update_highlight_usecase.dart';
import 'paper_reading_state.dart';

class PaperReadingCubit extends Cubit<PaperReadingState> {
  final GetPaperByIdUseCase getPaperByIdUseCase;
  final GetHighlightsUseCase getHighlightsUseCase;
  final SaveHighlightUseCase saveHighlightUseCase;
  final UpdateHighlightUseCase updateHighlightUseCase;
  final DeleteHighlightUseCase deleteHighlightUseCase;

  static const _uuid = Uuid();

  String _normalizeCssColor(String color) {
    final clean = color.replaceAll('#', '').toUpperCase();
    if (clean.length == 6) return '#$clean';
    if (clean.length == 8) return '#${clean.substring(2)}';
    return '#FFE082';
  }

  PaperReadingCubit({
    required this.getPaperByIdUseCase,
    required this.getHighlightsUseCase,
    required this.saveHighlightUseCase,
    required this.updateHighlightUseCase,
    required this.deleteHighlightUseCase,
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

    // Save to repository
    final result = await updateHighlightUseCase(updatedHighlight);
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
