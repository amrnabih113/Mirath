import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/services/local_storage_service.dart';
import 'package:mirath/core/utils/my_constants.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_logger.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/home/domain/entities/paper_entity.dart';
import 'package:mirath/features/paper_annotations/domain/entites/highlight_entity.dart';
import 'package:mirath/features/paper_annotations/presentation/cubit/paper_reading_cubit.dart';
import 'package:mirath/features/paper_annotations/presentation/cubit/paper_reading_state.dart';
import 'package:mirath/features/paper_annotations/presentation/widgets/annotation_webview.dart';
import 'package:mirath/features/paper_annotations/presentation/widgets/font_size_sheet.dart';
import 'package:mirath/features/paper_annotations/presentation/widgets/highlights_list_sheet.dart';
import 'package:mirath/features/paper_annotations/presentation/widgets/note_dialog.dart';
import 'package:mirath/features/paper_annotations/presentation/widgets/notes_list_sheet.dart';
import 'package:mirath/features/paper_annotations/presentation/widgets/paper_reading_shimmer_loading.dart';
import 'package:mirath/features/paper_annotations/presentation/widgets/reader_action_menu.dart';
import 'package:mirath/features/paper_annotations/presentation/widgets/reader_scroll_indicator.dart';
import 'package:mirath/features/paper_annotations/presentation/widgets/selection_overlay.dart';
import 'package:mirath/features/paper_annotations/presentation/widgets/translation_sheet.dart';
import 'package:mirath/generated/l10n.dart';
import 'package:mirath/injection/injection_container.dart';

class PaperReadingScreen extends StatefulWidget {
  final PaperEntity? paper;
  final String? paperId;
  final VoidCallback? backonTap;

  const PaperReadingScreen({super.key, this.paper, this.paperId, this.backonTap});

  @override
  State<PaperReadingScreen> createState() => _PaperReadingScreenState();
}

class _PaperReadingScreenState extends State<PaperReadingScreen> {
  final GlobalKey<AnnotationWebViewState> _webKey =
      GlobalKey<AnnotationWebViewState>();
  final TextEditingController _searchController = TextEditingController();
  AnnotationSelectionData? _currentSelection;
  AnnotationSelectionData? _pendingSelection;
  Highlight? _activeHighlight;
  SelectionPosition? _activeHighlightPosition;
  bool _showSelectionColorPicker = false;
  final Set<String> _renderedHighlightIds = <String>{};
  bool _isWebViewReady = false;
  String? _activePaperId;

  String _normalizeCssColor(String color) {
    final clean = color.replaceAll('#', '').toUpperCase();
    if (clean.length == 6) return '#$clean';
    if (clean.length == 8) return '#${clean.substring(2)}';
    return '#FFE082';
  }

  Map<String, dynamic> _highlightMetadata(Highlight highlight) {
    return {
      'xpathStart': highlight.xpathStart,
      'xpathEnd': highlight.xpathEnd,
      'startOffset': highlight.startOffset,
      'endOffset': highlight.endOffset,
      'plainText': highlight.plainText,
      'htmlContent': highlight.htmlContent,
      'contextBefore': highlight.contextBefore,
      'contextAfter': highlight.contextAfter,
      'firstWord': highlight.firstWord,
      'lastWord': highlight.lastWord,
      'selectedWordCount': highlight.selectedWordCount,
      'selectedCharLength': highlight.selectedCharLength,
    };
  }

  String _highlightSignature(List<Highlight> highlights) {
    return highlights
        .map(
          (highlight) =>
              '${highlight.id}:${highlight.note ?? ''}:${highlight.color}',
        )
        .join('|');
  }

  Future<bool> _attemptScrollToHighlight(
    String highlightId, {
    int attempts = 3,
    int delayMs = 120,
  }) async {
    MyLogger.info(
      '[ScrollDebug] Attempting to scroll to highlight: $highlightId (attempts: $attempts)',
    );
    for (int i = 0; i < attempts; i++) {
      final webViewState = _webKey.currentState;
      MyLogger.debug(
        '[ScrollDebug] Attempt ${i + 1}/$attempts, WebView ready: ${webViewState != null}',
      );
      if (webViewState != null) {
        final didScroll = await webViewState.scrollToHighlight(highlightId);
        MyLogger.info(
          '[ScrollDebug] Attempt ${i + 1} result: didScroll=$didScroll',
        );
        if (didScroll) return true;
      }

      if (i < attempts - 1) {
        MyLogger.debug('[ScrollDebug] Waiting ${delayMs}ms before retry');
        await Future<void>.delayed(Duration(milliseconds: delayMs));
      }
    }
    MyLogger.warning('[ScrollDebug] All scroll attempts failed');
    return false;
  }

  Future<void> _focusHighlightFromList(Highlight highlight) async {
    MyLogger.info(
      '[ScrollDebug] _focusHighlightFromList called for highlight: ${highlight.id}',
    );
    await Future<void>.delayed(const Duration(milliseconds: 260));

    bool didScroll = await _attemptScrollToHighlight(
      highlight.id,
      attempts: 3,
      delayMs: 140,
    );

    if (!didScroll) {
      MyLogger.info('[ScrollDebug] First attempt failed, restoring highlight');
      final restored =
          await _webKey.currentState?.restoreHighlight(
            highlight.id,
            highlight.getMatchText(),
            _normalizeCssColor(highlight.color),
            _highlightMetadata(highlight),
          ) ??
          false;
      MyLogger.debug('[ScrollDebug] Restore result: $restored');

      if (restored) {
        _renderedHighlightIds.add(highlight.id);
        didScroll = await _attemptScrollToHighlight(
          highlight.id,
          attempts: 4,
          delayMs: 160,
        );
      }
    }

    if (!didScroll) {
      MyLogger.info(
        '[ScrollDebug] Second attempt failed, restoring all highlights',
      );
      final state = context.read<PaperReadingCubit>().state;
      if (state is PaperReadingLoaded) {
        await _syncHighlightsToWebView(state.highlights);
        await Future<void>.delayed(const Duration(milliseconds: 180));
        didScroll = await _attemptScrollToHighlight(
          highlight.id,
          attempts: 4,
          delayMs: 180,
        );
      }
    }

    if (!mounted) return;

    if (!didScroll) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).error_note_not_located),
          duration: Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      _currentSelection = null;
      _pendingSelection = null;
      _showSelectionColorPicker = false;
      _activeHighlight = null;
      _activeHighlightPosition = null;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.paper != null) {
      print(
        '[PaperReadingScreen] initState - Paper: ${widget.paper!.id} - ${widget.paper!.title}',
      );
      context.read<PaperReadingCubit>().loadPaper(widget.paper!);
    } else if (widget.paperId != null) {
      final minimal = PaperEntity(
        id: widget.paperId!,
        title: '',
        abstract: '',
        publishedAt: DateTime.now(),
        authors: const [],
        categories: const [],
        isSaved: false,
        preprint: '',
        citation: '',
      );
      context.read<PaperReadingCubit>().loadPaper(minimal);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _dismissContextDialogs() {
    if (!mounted) return;
    setState(() {
      _currentSelection = null;
      _pendingSelection = null;
      _activeHighlight = null;
      _activeHighlightPosition = null;
      _showSelectionColorPicker = false;
    });
  }

  void _showComingSoonMessage(String action) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action ${S.of(context).coming_soon_message}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String? _currentTranslatableText() {
    final active = _activeHighlight;
    if (active != null && active.selectedText.trim().isNotEmpty) {
      return active.selectedText.trim();
    }

    final selection = _currentSelection ?? _pendingSelection;
    if (selection != null && selection.text.trim().isNotEmpty) {
      return selection.text.trim();
    }

    return null;
  }

  Future<void> _openTranslateSheet() async {
    final text = _currentTranslatableText();
    if (text == null || text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).error_select_text_translate)),
      );
      return;
    }

    final storage = sl<LocalStorageService>();
    final savedLanguageCode = storage.getData(
      MyConstants.annotationTranslationLanguageKey,
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.92,
          child: TranslationSheet(
            text: text,
            initialTargetLanguageCode: savedLanguageCode,
            onTargetLanguageChanged: (languageCode) {
              return storage.setData(
                MyConstants.annotationTranslationLanguageKey,
                languageCode,
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _onHighlightTapped(AnnotationHighlightTapData tapData) async {
    final state = context.read<PaperReadingCubit>().state;
    if (state is! PaperReadingLoaded) return;

    final matchingHighlights = state.highlights
        .where((h) => h.id == tapData.id)
        .toList();
    if (matchingHighlights.isEmpty) return;

    if (!mounted) return;
    setState(() {
      _currentSelection = null;
      _pendingSelection = null;
      _showSelectionColorPicker = false;
      _activeHighlight = matchingHighlights.first;
      _activeHighlightPosition = SelectionPosition(
        x: tapData.x,
        y: tapData.y,
        width: tapData.width,
        height: tapData.height,
      );
    });
  }

  Future<void> _updateActiveHighlightColor(String color) async {
    final highlight = _activeHighlight;
    if (highlight == null) return;

    final cssColor = _normalizeCssColor(color);
    await _webKey.currentState?.updateHighlightColor(highlight.id, cssColor);
    if (!mounted) return;
    await context.read<PaperReadingCubit>().updateHighlightColor(
      highlight.id,
      cssColor,
    );

    if (!mounted) return;
    setState(() {
      _activeHighlight = highlight.copyWithColor(cssColor);
    });
  }

  Future<void> _removeActiveHighlight() async {
    final highlight = _activeHighlight;
    if (highlight == null) return;

    await _webKey.currentState?.removeHighlight(highlight.id);
    _renderedHighlightIds.remove(highlight.id);
    if (!mounted) return;
    await context.read<PaperReadingCubit>().deleteHighlight(highlight.id);

    if (!mounted) return;
    setState(() {
      _activeHighlight = null;
      _activeHighlightPosition = null;
    });
  }

  void _searchNow() {
    final text = _searchController.text.trim();
    if (text.isEmpty) return;

    _webKey.currentState
        ?.searchText(text)
        .then((result) {
          if (!mounted) return;

          print('[Search] Result: $result');

          final total = (result['total'] as num?)?.toInt() ?? 0;
          final current = (result['current'] as num?)?.toInt() ?? 0;

          print('[Search] Total: $total, Current: $current');

          context.read<PaperReadingCubit>().updateSearchResults(
            text,
            current,
            total,
          );
        })
        .catchError((error) {
          print('[Search] Error: $error');
        });
  }

  void _searchNext() {
    _webKey.currentState?.searchNext().then((result) {
      if (!mounted) return;
      final total = (result['total'] as num?)?.toInt() ?? 0;
      final current = (result['current'] as num?)?.toInt() ?? 0;
      final state = context.read<PaperReadingCubit>().state;
      if (state is PaperReadingLoaded) {
        context.read<PaperReadingCubit>().updateSearchResults(
          state.searchQuery,
          current,
          total,
        );
      }
    });
  }

  void _searchPrevious() {
    _webKey.currentState?.searchPrevious().then((result) {
      if (!mounted) return;
      final total = (result['total'] as num?)?.toInt() ?? 0;
      final current = (result['current'] as num?)?.toInt() ?? 0;
      final state = context.read<PaperReadingCubit>().state;
      if (state is PaperReadingLoaded) {
        context.read<PaperReadingCubit>().updateSearchResults(
          state.searchQuery,
          current,
          total,
        );
      }
    });
  }

  void _closeSearch() {
    _webKey.currentState?.clearSearch();
    _searchController.clear();
    context.read<PaperReadingCubit>().closeSearch();
  }

  Future<void> _showHighlightsList(List<Highlight> highlights) async {
    MyLogger.info('[ScrollDebug] Opening highlights list');
    if (mounted) {
      setState(() {
        _currentSelection = null;
        _pendingSelection = null;
        _activeHighlight = null;
        _activeHighlightPosition = null;
        _showSelectionColorPicker = false;
      });
    }

    final selected = await showModalBottomSheet<Highlight>(
      context: context,
      showDragHandle: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.95,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: MyColors.light,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: HighlightsListSheet(
            highlights: highlights,
            scrollController: controller,
          ),
        ),
      ),
    );

    MyLogger.debug(
      '[ScrollDebug] Highlights sheet closed, selected: ${selected?.id}',
    );
    if (selected == null) return;
    await _focusHighlightFromList(selected);
  }

  Future<void> _showNotesList() async {
    MyLogger.info('[ScrollDebug] Opening notes list');
    if (mounted) {
      setState(() {
        _currentSelection = null;
        _pendingSelection = null;
        _activeHighlight = null;
        _activeHighlightPosition = null;
        _showSelectionColorPicker = false;
      });
    }

    await context.read<PaperReadingCubit>().loadAnnotatedHighlights(
      widget.paper!.id,
    );

    final selected = await showModalBottomSheet<NotesListSheetResult>(
      context: context,
      showDragHandle: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<PaperReadingCubit>(),
        child: BlocBuilder<PaperReadingCubit, PaperReadingState>(
          builder: (blocContext, state) {
            if (state is! PaperReadingLoaded) {
              return Container(
                color: MyColors.light,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final notesWithNotes = state.highlights
                .where((h) => h.note?.isNotEmpty == true)
                .toList();

            return DraggableScrollableSheet(
              initialChildSize: 0.95,
              maxChildSize: 0.95,
              builder: (_, controller) => Container(
                decoration: BoxDecoration(
                  color: MyColors.light,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: NotesListSheet(
                  highlights: notesWithNotes,
                  scrollController: controller,
                  isLoadingMore: state.annotatedHighlightLoading,
                  hasMore: state.annotatedHighlightHasMore,
                  onLoadMore: () {
                    blocContext
                        .read<PaperReadingCubit>()
                        .loadMoreAnnotatedHighlights(widget.paper!.id);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );

    MyLogger.debug(
      '[ScrollDebug] Notes sheet closed, selected: ${selected?.highlight.id}',
    );
    if (selected == null) return;
    if (selected.action == NotesListSheetAction.edit) {
      final highlight = selected.highlight;
      await _openNoteEditor(
        selectedText: highlight.selectedText,
        selectedHtmlContent: highlight.htmlContent,
        selectedColorHex: highlight.color,
        initialNote: highlight.note ?? '',
        onSave: (note) async {
          if (!mounted) return;
          await context.read<PaperReadingCubit>().updateHighlightNote(
            highlight.id,
            note,
          );
        },
        onDelete: () async {
          await context.read<PaperReadingCubit>().deleteHighlightNote(
            highlight.id,
          );
        },
      );
      return;
    }

    await _focusHighlightFromList(selected.highlight);
  }

  Future<void> _openNoteEditor({
    required String selectedText,
    String? selectedHtmlContent,
    String? selectedColorHex,
    required String initialNote,
    required Future<void> Function(String note) onSave,
    Future<void> Function()? onDelete,
  }) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (pageContext) {
          return NoteDialog(
            selectedText: selectedText,
            selectedHtmlContent: selectedHtmlContent,
            selectedColorHex: selectedColorHex,
            initialNote: initialNote,
            onSave: (note) async {
              await onSave(note);
              if (!mounted) return;
              Navigator.of(pageContext).pop();
            },
            onDelete: onDelete == null
                ? null
                : () async {
                    await onDelete();
                    Navigator.of(pageContext).pop();
                  },
          );
        },
      ),
    );
  }

  Future<void> _showNoteForActiveHighlight() async {
    final highlight = _activeHighlight;
    if (highlight == null) return;

    await _openNoteEditor(
      selectedText: highlight.selectedText,
      selectedHtmlContent: highlight.htmlContent,
      selectedColorHex: highlight.color,
      initialNote: highlight.note ?? '',
      onSave: (note) async {
        if (!mounted) return;
        await context.read<PaperReadingCubit>().updateHighlightNote(
          highlight.id,
          note,
        );
        if (!mounted) return;
        setState(() {
          _activeHighlight = highlight.copyWith(note: note);
        });
      },
      onDelete: () async {
        await context.read<PaperReadingCubit>().deleteHighlightNote(
          highlight.id,
        );
        if (!mounted) return;
        setState(() {
          _activeHighlight = highlight.copyWith(note: '');
        });
      },
    );
  }

  void _showFontSizeDialog(double currentScale) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: false,

      builder: (dialogContext) {
        return FontSizeSheet(
          currentScale: currentScale,
          onScaleChanged: (scale) {
            _webKey.currentState?.setFontScale(scale);
            context.read<PaperReadingCubit>().updateFontScale(scale);
          },
        );
      },
    );
  }

  Future<void> _syncHighlightsToWebView(List<Highlight> highlights) async {
    if (!_isWebViewReady) return;

    final paperId = highlights.isNotEmpty
        ? highlights.first.paperId
        : _activePaperId;
    if (paperId != null && _activePaperId != paperId) {
      _activePaperId = paperId;
      _renderedHighlightIds.clear();
    }

    final currentHighlightIds = highlights
        .map((highlight) => highlight.id)
        .toSet();

    final removedHighlightIds = _renderedHighlightIds
        .where((id) => !currentHighlightIds.contains(id))
        .toList();
    for (final highlightId in removedHighlightIds) {
      await _webKey.currentState?.removeHighlight(highlightId);
      _renderedHighlightIds.remove(highlightId);
    }

    for (final highlight in highlights) {
      if (_renderedHighlightIds.contains(highlight.id)) continue;

      final normalizedCssColor = _normalizeCssColor(highlight.color);
      final metadata = _highlightMetadata(highlight);
      final restored =
          await _webKey.currentState?.restoreHighlight(
            highlight.id,
            highlight.getMatchText(),
            normalizedCssColor,
            metadata,
          ) ??
          false;

      if (restored) {
        _renderedHighlightIds.add(highlight.id);
      }
    }
  }

  Future<void> _createHighlightFromSelection(String color) async {
    final selection = _currentSelection ?? _pendingSelection;
    if (selection == null) return;
    final cssColor = _normalizeCssColor(color);
    final highlightId =
        '${DateTime.now().millisecondsSinceEpoch}_${selection.text.hashCode}';
    final applied =
        await _webKey.currentState?.applyHighlight(
          highlightId,
          selection.text,
          cssColor,
          selection.toHighlightMetadata(),
        ) ??
        false;

    if (!applied) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).error_highlight_placement)),
      );
      return;
    }

    _renderedHighlightIds.add(highlightId);
    if (!mounted) return;
    await context.read<PaperReadingCubit>().addHighlight(
      highlightId: highlightId,
      selectedText: selection.text,
      color: cssColor,
      xpathStart: selection.xpathStart,
      xpathEnd: selection.xpathEnd,
      startOffset: selection.startOffset,
      endOffset: selection.endOffset,
      plainText: selection.plainText,
      htmlContent: selection.htmlContent,
      contextBefore: selection.contextBefore,
      contextAfter: selection.contextAfter,
      firstWord: selection.firstWord,
      lastWord: selection.lastWord,
      selectedWordCount: selection.wordCount,
      selectedCharLength: selection.selectedCharLength,
    );
    if (!mounted) return;
    setState(() {
      _currentSelection = null;
      _pendingSelection = null;
      _showSelectionColorPicker = false;
    });
  }

  Future<void> _showNoteFromSelection() async {
    final selection = _currentSelection ?? _pendingSelection;
    if (selection == null) return;

    final highlightId =
        '${DateTime.now().millisecondsSinceEpoch}_${selection.text.hashCode}_note';
    const noteColor = '#FFE082';

    final applied =
        await _webKey.currentState?.applyHighlight(
          highlightId,
          selection.text,
          noteColor,
          selection.toHighlightMetadata(),
        ) ??
        false;

    if (!applied) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).error_note_placement)),
      );
      return;
    }

    setState(() {
      _currentSelection = null;
      _pendingSelection = null;
      _showSelectionColorPicker = false;
    });

    _renderedHighlightIds.add(highlightId);

    await _openNoteEditor(
      selectedText: selection.text,
      selectedHtmlContent: selection.htmlContent,
      selectedColorHex: noteColor,
      initialNote: '',
      onSave: (note) async {
        if (!mounted) return;
        await context.read<PaperReadingCubit>().addHighlight(
          highlightId: highlightId,
          selectedText: selection.text,
          color: noteColor,
          note: note,
          xpathStart: selection.xpathStart,
          xpathEnd: selection.xpathEnd,
          startOffset: selection.startOffset,
          endOffset: selection.endOffset,
          plainText: selection.plainText,
          htmlContent: selection.htmlContent,
          contextBefore: selection.contextBefore,
          contextAfter: selection.contextAfter,
          firstWord: selection.firstWord,
          lastWord: selection.lastWord,
          selectedWordCount: selection.wordCount,
          selectedCharLength: selection.selectedCharLength,
        );
      },
      onDelete: () async {
        await _webKey.currentState?.removeHighlight(highlightId);
        _renderedHighlightIds.remove(highlightId);
      },
    );
  }

  Future<void> _handleNoteAction() async {
    if (_activeHighlight != null) {
      await _showNoteForActiveHighlight();
      return;
    }
    await _showNoteFromSelection();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaperReadingCubit, PaperReadingState>(
      listenWhen: (previous, current) {
        if (current is PaperReadingLoaded && current.highlights.isNotEmpty) {
          if (previous is! PaperReadingLoaded ||
              _highlightSignature(previous.highlights) !=
                  _highlightSignature(current.highlights)) {
            return true;
          }
        }
        return false;
      },
      listener: (context, state) {
        if (state is PaperReadingLoaded && _isWebViewReady) {
          print(
            '[PaperReadingScreen] Highlights loaded (${state.highlights.length}), restoring to WebView',
          );
          _syncHighlightsToWebView(state.highlights);
        }
      },
      child: BlocBuilder<PaperReadingCubit, PaperReadingState>(
        buildWhen: (previous, current) {
          // Rebuild on state type changes
          if (previous.runtimeType != current.runtimeType) return true;
          if (current is PaperReadingLoaded && previous is PaperReadingLoaded) {
            // Rebuild on content, menu, scroll, font scale, or search changes
            return current.paperHtml != previous.paperHtml ||
                current.paper.id != previous.paper.id ||
                current.menuOpen != previous.menuOpen ||
                current.scrollProgress != previous.scrollProgress ||
                current.fontScale != previous.fontScale ||
                current.searchOpen != previous.searchOpen ||
                _highlightSignature(current.highlights) !=
                    _highlightSignature(previous.highlights);
          }
          return false;
        },
        builder: (context, state) {
          print('[PaperReadingScreen] build - State: ${state.runtimeType}');

          if (state is PaperReadingLoading) {
            print('[PaperReadingScreen] Showing loading state');
            return const PaperReadingShimmerLoading();
          }

          if (state is PaperReadingError) {
            print('[PaperReadingScreen] Showing error state: ${state.message}');
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(),
              body: Center(
                child: Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }

          if (state is! PaperReadingLoaded) {
            print(
              '[PaperReadingScreen] State is not loaded, showing shimmer loading',
            );
            return const PaperReadingShimmerLoading();
          }

          print(
            '[PaperReadingScreen] Rendering loaded state with HTML length: ${state.paperHtml.length}',
          );

          final noteCount = state.highlights
              .where((h) => h.note?.isNotEmpty == true)
              .length;

          return Scaffold(
            bottomNavigationBar: Padding(
              padding: EdgeInsets.all(MySizes.spaceMd(context)),
              child: ReaderScrollIndicator(progress: state.scrollProgress),
            ),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(
                ResponsiveHelper.responsiveValue(context, 56),
              ),
              child: Center(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 850),
                      child: AppBar(
                        leading: state.searchOpen ? null : const MyBackIcon(),
                        automaticallyImplyLeading: !state.searchOpen,
                        title: state.searchOpen
                            ? null
                            : null, // No title in normal mode
                        actions: state.searchOpen
                            ? [
                                // Search mode: show search field and controls
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: MySizes.spaceMd(context),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _searchController,
                                            autofocus: true,
                                            decoration: InputDecoration(
                                              hintText: S
                                                  .of(context)
                                                  .search_in_paper_hint,
                                              hintStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: Colors.grey,
                                                  ),

                                              isDense: true,
                                            ),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                            onSubmitted: (_) => _searchNow(),
                                            onChanged: (_) => _searchNow(),
                                          ),
                                        ),
                                        if (state.searchTotal > 0) ...[
                                          SizedBox(
                                            width: MySizes.spaceSm(context),
                                          ),
                                          Text(
                                            '${state.searchCurrent}/${state.searchTotal}',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                        ],
                                        IconButton(
                                          onPressed: state.searchTotal > 0
                                              ? _searchPrevious
                                              : null,
                                          icon: const Icon(
                                            Icons.keyboard_arrow_up,
                                          ),
                                          iconSize: MySizes.iconMedium(context),
                                          tooltip: S
                                              .of(context)
                                              .previous_button,
                                        ),
                                        IconButton(
                                          onPressed: state.searchTotal > 0
                                              ? _searchNext
                                              : null,
                                          icon: const Icon(
                                            Icons.keyboard_arrow_down,
                                          ),
                                          iconSize: MySizes.iconMedium(context),
                                          tooltip: S.of(context).next,
                                        ),
                                        IconButton(
                                          onPressed: _closeSearch,
                                          icon: const Icon(Icons.close),
                                          iconSize: MySizes.iconMedium(context),
                                          tooltip: S
                                              .of(context)
                                              .close_search_button,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]
                            : [],
                      ),
                    );
                  },
                ),
              ),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AnnotationWebView(
                      key: _webKey,
                      content: state.paperHtml,
                      paperId: state.paper.id,
                      title: state.paper.title,
                      authors: state.paper.authors,
                      onSelectionChanged: (selection) {
                        if (!mounted) return;
                        debugPrint(
                          '[PaperReadingScreen] Text selected: "${selection.text}" at (${selection.x}, ${selection.y})',
                        );
                        setState(() {
                          _currentSelection = selection;
                          _pendingSelection = selection;
                          _activeHighlight = null;
                          _activeHighlightPosition = null;
                          _showSelectionColorPicker = false;
                        });
                      },
                      onSelectionCleared: () {
                        if (!mounted) return;
                        setState(() {
                          _currentSelection = null;
                          _activeHighlightPosition = null;
                          _showSelectionColorPicker = false;
                        });
                      },
                      onHighlightTapped: _onHighlightTapped,
                      onScrollProgress: (value) {
                        context.read<PaperReadingCubit>().updateScrollProgress(
                          value,
                        );
                      },
                      onReady: () async {
                        _isWebViewReady = true;
                        await _webKey.currentState?.setFontScale(
                          state.fontScale,
                        );
                        await _syncHighlightsToWebView(state.highlights);
                      },
                    ),
                  ),

                  // Action menu
                  Positioned(
                    right: MySizes.paddingMd(context).right,
                    bottom: ResponsiveHelper.responsiveValue(context, 88),
                    child: ReaderActionMenu(
                      isOpen: state.menuOpen,
                      onToggle: () {
                        context.read<PaperReadingCubit>().toggleMenu();
                      },
                      onSearchTap: () {
                        context.read<PaperReadingCubit>().openSearch();
                      },
                      onNotesTap: () async {
                        context.read<PaperReadingCubit>().closeMenu();
                        await _showNotesList();
                      },
                      onHighlightsTap: () {
                        context.read<PaperReadingCubit>().closeMenu();
                        _showHighlightsList(state.highlights);
                      },
                      onThemesTap: () {
                        context.read<PaperReadingCubit>().closeMenu();
                        _showFontSizeDialog(state.fontScale);
                      },
                      highlightCount: state.highlights.length,
                      noteCount: noteCount,
                    ),
                  ),
                  // Action menu
                  Positioned(
                    right: MySizes.paddingMd(context).right,
                    bottom: ResponsiveHelper.responsiveValue(context, 20),
                    child: FloatingActionButton(
                      heroTag: 'paper-reading-ai-fab',
                      shape: CircleBorder(),
                      backgroundColor: MyColors.primaryShade700,
                      foregroundColor: MyColors.primaryShade50,
                      onPressed: () {},
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedStars,
                        size: MySizes.iconMedium(context),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Selection context menu - must be last in stack to appear on top
                  if (_currentSelection != null || _activeHighlight != null)
                    Positioned.fill(
                      child: AnnotationSelectionOverlay(
                        position: _currentSelection != null
                            ? SelectionPosition(
                                x: _currentSelection!.x,
                                y: _currentSelection!.y,
                                width: _currentSelection!.width,
                                height: _currentSelection!.height,
                              )
                            : (_activeHighlightPosition ??
                                  SelectionPosition(
                                    x:
                                        (MediaQuery.of(context).size.width -
                                            340) /
                                        2,
                                    y: 100,
                                    width: 340,
                                    height: 0,
                                  )),
                        mode: _activeHighlight != null
                            ? AnnotationDialogMode.highlightColors
                            : (_showSelectionColorPicker
                                  ? AnnotationDialogMode.selectionColors
                                  : AnnotationDialogMode.selectionActions),
                        onDismiss: _dismissContextDialogs,
                        selectedColor: _activeHighlight?.color,
                        onSelectColor: (color) {
                          if (_activeHighlight != null) {
                            _updateActiveHighlightColor(color);
                            return;
                          }
                          _createHighlightFromSelection(color);
                        },
                        onHighlightPressed: () {
                          if (!mounted) return;
                          setState(() {
                            _showSelectionColorPicker = true;
                          });
                        },
                        onNote: _handleNoteAction,
                        noteActionLabel:
                            _activeHighlight?.note?.trim().isNotEmpty == true
                            ? S.of(context).edit_note_button
                            : S.of(context).add_note_button,
                        onExplain: () => _showComingSoonMessage('Explain'),
                        onTranslate: _openTranslateSheet,
                        onRemove: _activeHighlight != null
                            ? _removeActiveHighlight
                            : null,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
