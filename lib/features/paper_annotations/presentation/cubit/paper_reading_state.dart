import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/paper_entity.dart';
import '../../domain/entites/highlight_entity.dart';
import '../widgets/annotation_webview_platform.dart';

abstract class PaperReadingState extends Equatable {
  const PaperReadingState();

  @override
  List<Object?> get props => [];
}

class PaperReadingInitial extends PaperReadingState {
  const PaperReadingInitial();
}

class PaperReadingLoading extends PaperReadingState {
  const PaperReadingLoading();
}

class PaperReadingLoaded extends PaperReadingState {
  final PaperEntity paper;
  final String paperHtml;
  final List<Highlight> highlights;
  final AnnotationSelectionData? currentSelection;
  final double scrollProgress;
  final double fontScale;

  // Search state
  final bool searchOpen;
  final String searchQuery;
  final int searchCurrent;
  final int searchTotal;

  // UI state
  final bool menuOpen;

  // Annotated highlights pagination state
  final int annotatedHighlightPage;
  final bool annotatedHighlightHasMore;
  final bool annotatedHighlightLoading;

  const PaperReadingLoaded({
    required this.paper,
    required this.paperHtml,
    required this.highlights,
    this.currentSelection,
    this.scrollProgress = 0.0,
    this.fontScale = 1.0,
    this.searchOpen = false,
    this.searchQuery = '',
    this.searchCurrent = 0,
    this.searchTotal = 0,
    this.menuOpen = false,
    this.annotatedHighlightPage = 1,
    this.annotatedHighlightHasMore = true,
    this.annotatedHighlightLoading = false,
  });

  PaperReadingLoaded copyWith({
    PaperEntity? paper,
    String? paperHtml,
    List<Highlight>? highlights,
    AnnotationSelectionData? currentSelection,
    bool clearSelection = false,
    double? scrollProgress,
    double? fontScale,
    bool? searchOpen,
    String? searchQuery,
    int? searchCurrent,
    int? searchTotal,
    bool? menuOpen,
    int? annotatedHighlightPage,
    bool? annotatedHighlightHasMore,
    bool? annotatedHighlightLoading,
  }) {
    return PaperReadingLoaded(
      paper: paper ?? this.paper,
      paperHtml: paperHtml ?? this.paperHtml,
      highlights: highlights ?? this.highlights,
      currentSelection: clearSelection
          ? null
          : (currentSelection ?? this.currentSelection),
      scrollProgress: scrollProgress ?? this.scrollProgress,
      fontScale: fontScale ?? this.fontScale,
      searchOpen: searchOpen ?? this.searchOpen,
      searchQuery: searchQuery ?? this.searchQuery,
      searchCurrent: searchCurrent ?? this.searchCurrent,
      searchTotal: searchTotal ?? this.searchTotal,
      menuOpen: menuOpen ?? this.menuOpen,
      annotatedHighlightPage:
          annotatedHighlightPage ?? this.annotatedHighlightPage,
      annotatedHighlightHasMore:
          annotatedHighlightHasMore ?? this.annotatedHighlightHasMore,
      annotatedHighlightLoading:
          annotatedHighlightLoading ?? this.annotatedHighlightLoading,
    );
  }

  @override
  List<Object?> get props => [
    paper,
    paperHtml,
    highlights,
    currentSelection,
    scrollProgress,
    fontScale,
    searchOpen,
    searchQuery,
    searchCurrent,
    searchTotal,
    menuOpen,
    annotatedHighlightPage,
    annotatedHighlightHasMore,
    annotatedHighlightLoading,
  ];
}

class PaperReadingError extends PaperReadingState {
  final String message;

  const PaperReadingError({required this.message});

  @override
  List<Object?> get props => [message];
}
