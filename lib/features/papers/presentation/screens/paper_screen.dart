import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/network/network_manager.dart';
import '../../../../core/services/sharing_service.dart';
import '../../../../core/ui/widgets/state_views.dart';
import '../../../../core/ui/widgets/my_body.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';
import '../../../../injection/injection_container.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../../home/domain/entities/paper_entity.dart';
import '../../../home/presentation/cubit/home_cubit.dart';
import '../../../reading_lists/presentation/widgets/add_to_reading_list_dialog.dart';
import '../../domain/usecases/get_paper_by_id_usecase.dart';
import '../widgets/abstract_section.dart';
import '../widgets/expainsion_tile_widget.dart';
import '../widgets/paper_info.dart';

class PaperScreen extends StatefulWidget {
  final PaperEntity? paper;
  final String? paperId;
  final VoidCallback? backonTap;

  const PaperScreen({super.key, this.paper, this.paperId, this.backonTap});

  @override
  State<PaperScreen> createState() => _PaperScreenState();
}

class _PaperScreenState extends State<PaperScreen> {
  PaperEntity? _currentPaper;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _currentPaper = widget.paper;
    if (_currentPaper == null && widget.paperId != null) {
      _fetchPaper(widget.paperId!);
    }
  }

  Future<void> _fetchPaper(String id) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final result = await sl<GetPaperByIdUseCase>()(id);
    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load paper';
        });
      },
      (full) {
        final paper = PaperEntity(
          id: full.id,
          title: full.title,
          abstract: full.abstract,
          publishedAt: full.publishedAt,
          authors: full.authors,
          categories: full.categories,
          isSaved: false,
          preprint: '',
          citation: full.citation,
        );
        setState(() {
          _currentPaper = paper;
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPaper = _currentPaper;

    if (_isLoading) {
      return Scaffold(body: MyBody(child: const Center(child: CircularProgressIndicator())));
    }
    if (_error != null) {
      final offline = !NetworkManager.instance.currentConnectionStatus;
      return Scaffold(
        body: offline
            ? OfflineStateView(
                title: 'Offline',
                message: _error!,
                actionLabel: 'Retry',
                onAction: () {
                  final id = widget.paperId ?? widget.paper?.id;
                  if (id != null) {
                    _fetchPaper(id);
                  }
                },
              )
            : Center(child: Text(_error!)),
      );
    }

    if (currentPaper == null) {
          return Scaffold(
        body: MyBody(child: Center(child: Text(S.of(context).error_no_paper_data))),
      );
    }

    return Scaffold(
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
                  leading: MyBackIcon(
                    onTap: () {
                      context.go(RouteNames.home);
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedMoreHorizontal,
                        size: MySizes.iconLarge(context),
                        color: Colors.black,
                      ),
                      onPressed: () => _showPaperMenu(context),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      body: MyBody(
        child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Padding(
                padding: MySizes.paddingMd(context),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PaperInfo(
                        paper: currentPaper,
                        onSavePressed: _onSavePressed,
                      ),
                      SizedBox(height: MySizes.spaceMd(context)),
                      AbstractSection(
                        abstractText: currentPaper.abstract,
                        onStartDiscussion: _onStartDiscussion,
                        onViewDiscussions: _onViewDiscussions,
                      ),
                      SizedBox(height: MySizes.spaceMd(context)),
                      ExpainsionTileWidget(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      )  );
  }

  void _onSavePressed() {
    showDialog(
      context: context,
      builder: (context) => AddToReadingListDialog(
        paperId: _currentPaper!.id,
        isSaved: _currentPaper!.isSaved,
        onSavedStatusChanged: (isSaved) {
          setState(() {
            _currentPaper = _currentPaper!.copyWith(isSaved: isSaved);
          });
          // Refetch papers from API to get updated data
          try {
            context.read<HomeCubit>().loadAllPapers();
          } catch (e) {
            // HomeCubit might not be available if navigated from other routes
          }
        },
      ),
    );
  }

  void _showPaperMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const HugeIcon(icon: HugeIcons.strokeRoundedShare08),
              title: const Text('Share Paper'),
              onTap: () {
                Navigator.pop(context);
                SharingService.sharePaper(_currentPaper!);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onStartDiscussion() {
    context.push(RouteNames.addDiscussion, extra: _currentPaper);
  }

  void _onViewDiscussions() {
    context.push(
      RouteNames.paperDiscussionsRoute(_currentPaper!.id),
      extra: _currentPaper,
    );
  }
}
