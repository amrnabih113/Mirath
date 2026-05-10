import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/home/presentation/widgets/home_shimmer_loading.dart';
import 'package:mirath/features/home/presentation/widgets/paper_card.dart';
import 'package:mirath/features/library/presentation/cubit/library_cubit.dart';

class ReadingHistoryScreen extends StatefulWidget {
  const ReadingHistoryScreen({super.key});

  @override
  State<ReadingHistoryScreen> createState() => _ReadingHistoryScreenState();
}

class _ReadingHistoryScreenState extends State<ReadingHistoryScreen> {
  static const int _pageSize = 20;
  late final ScrollController _scrollController;
  final Set<String> _selectedPaperIds = <String>{};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isSelectionMode => _selectedPaperIds.isNotEmpty;

  void _toggleSelection(String paperId) {
    setState(() {
      if (_selectedPaperIds.contains(paperId)) {
        _selectedPaperIds.remove(paperId);
      } else {
        _selectedPaperIds.add(paperId);
      }
    });
  }

  void _enterSelectionMode(String paperId) {
    setState(() {
      _selectedPaperIds.add(paperId);
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _selectedPaperIds.clear();
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels < threshold) return;

    final currentState = context.read<LibraryCubit>().state;
    if (currentState is GetReadingHistorySuccess && currentState.hasMore) {
      context.read<LibraryCubit>().getReadingHistory(
        page: currentState.currentPage + 1,
        limit: _pageSize,
        loadMore: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MyBackIcon(
          onTap: () {
            if (_isSelectionMode) {
              _exitSelectionMode();
              return;
            }
            Navigator.of(context).maybePop();
          },
        ),
        title: Text(
          'Reading History',
          style: context.headlineLarge.copyWith(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: _isSelectionMode
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextButton.icon(
                    onPressed: _selectedPaperIds.isEmpty
                        ? null
                        : _confirmAndDeleteSelected,
                    icon: const Icon(Icons.checklist_rtl_outlined),
                    label: Text(
                      'Delete selected (${_selectedPaperIds.length})',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextButton.icon(
                    onPressed: _confirmAndClearAll,
                    icon: const Icon(Icons.delete_forever_outlined),
                    label: const Text('Delete all'),
                  ),
                ),
              ]
            : [],
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Padding(
                padding: MySizes.paddingSm(context),
                child: BlocBuilder<LibraryCubit, LibraryState>(
                  builder: (context, state) {
                    if (state is GetReadingHistoryLoading) {
                      return const PaperListShimmer();
                    }

                    if (state is GetReadingHistoryFailure) {
                      return Center(
                        child: Text(
                          state.errorMessage,
                          style: context.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    if (state is GetReadingHistorySuccess) {
                      if (state.readingHistory.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('You haven’t read any research papers'),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Explore',
                                style: context.bodyLarge.copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2,
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8),
                        itemCount:
                            state.readingHistory.length +
                            (state.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= state.readingHistory.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          return PaperCard(
                            paper: state.readingHistory[index].paper,
                            isHistory: true,
                            lastReadAt: state.readingHistory[index].viewedAt,
                            isSelected: _selectedPaperIds.contains(
                              state.readingHistory[index].paperId,
                            ),
                            onTap: () {
                              final paperId =
                                  state.readingHistory[index].paperId;
                              if (_isSelectionMode) {
                                _toggleSelection(paperId);
                                return;
                              }

                              final paper = state.readingHistory[index].paper;
                              context.push(
                                RouteNames.paperDetailsRoute(paper.id),
                                extra: paper,
                              );
                            },
                            onLongPress: () {
                              _enterSelectionMode(
                                state.readingHistory[index].paperId,
                              );
                            },
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: MySizes.spaceXs(context) * 0.5),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmAndDeleteSelected() async {
    final state = context.read<LibraryCubit>().state;
    if (state is! GetReadingHistorySuccess || _selectedPaperIds.isEmpty) {
      return;
    }

    final selectedItems = state.readingHistory
        .where((item) => _selectedPaperIds.contains(item.paperId))
        .toList();
    if (selectedItems.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete selected history items?'),
        content: Text(
          'Remove ${selectedItems.length} selected papers from your reading history?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final cubit = context.read<LibraryCubit>();
    for (final item in selectedItems) {
      await cubit.removePaperFromReadingHistory(item.paperId);
    }

    if (!mounted) return;
    await cubit.getReadingHistory(page: 1, limit: _pageSize);
    if (!mounted) return;
    _exitSelectionMode();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selected history items deleted')),
    );
  }

  Future<void> _confirmAndClearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete all history?'),
        content: const Text(
          'This will remove every paper from your reading history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final cubit = context.read<LibraryCubit>();
    await cubit.clearAllReadingHistory();
    if (!mounted) return;

    if (cubit.state is ClearAllReadingHistorySuccess) {
      await cubit.getReadingHistory(page: 1, limit: _pageSize);
      if (!mounted) return;
      _exitSelectionMode();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Reading history cleared')));
    }
  }
}
