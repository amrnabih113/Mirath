import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../../home/presentation/widgets/home_shimmer_loading.dart';
import '../../../home/presentation/widgets/paper_card.dart';
import '../cubit/library_cubit.dart';
import '../../../../core/ui/widgets/my_app_bar.dart';
import '../../../../core/ui/widgets/my_body.dart';

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
      appBar: MyAppBar(
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
          'Reading history',
          style: context.titleLarge.copyWith(color: Colors.black),
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
      body: MyBody(
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
                itemCount:
                    state.readingHistory.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.readingHistory.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final item = state.readingHistory[index];
                  return PaperCard(
                    paper: item.paper,
                    isHistory: true,
                    lastReadAt: item.viewedAt,
                    isSelected: _selectedPaperIds.contains(item.paperId),
                    onTap: () {
                      final paperId = item.paperId;
                      if (_isSelectionMode) {
                        _toggleSelection(paperId);
                        return;
                      }

                      context.push(
                        RouteNames.paperDetailsRoute(item.paper.id),
                        extra: item.paper,
                      );
                    },
                    onLongPress: () => _enterSelectionMode(item.paperId),
                  );
                },
                separatorBuilder: (context, index) =>
                    SizedBox(height: MySizes.spaceLg(context)),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<void> _confirmAndDeleteSelected() async {
    final state = context.read<LibraryCubit>().state;
    if (state is! GetReadingHistorySuccess || _selectedPaperIds.isEmpty) return;

    final selectedItems = state.readingHistory
        .where((i) => _selectedPaperIds.contains(i.paperId))
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

    if (confirmed == true) {
      final cubit = context.read<LibraryCubit>();
      for (final id in selectedItems.map((e) => e.paperId)) {
        await cubit.removePaperFromReadingHistory(id);
        if (!mounted) return;
      }
      _exitSelectionMode();
      cubit.getReadingHistory();
    }
  }

  Future<void> _confirmAndClearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear reading history?'),
        content: const Text('Remove all papers from your reading history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final cubit = context.read<LibraryCubit>();
      await cubit.clearAllReadingHistory();
      if (!mounted) return;
      cubit.getReadingHistory();
    }
  }
}
