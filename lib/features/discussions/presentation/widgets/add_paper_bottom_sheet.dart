import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_search_bar.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/features/home/domain/entities/paper_entity.dart';
import 'package:mirath/features/home/presentation/cubit/home_cubit.dart';
import 'package:mirath/features/home/presentation/cubit/home_state.dart';
import 'package:mirath/features/home/presentation/widgets/paper_card.dart';
import 'package:mirath/features/home/presentation/widgets/paper_shimmer_loading.dart';

class AddPaperBottomSheet extends StatefulWidget {
  final ValueChanged<PaperEntity> onPaperSelected;
  final List<PaperEntity> selectedPapers;

  const AddPaperBottomSheet({
    super.key,
    required this.onPaperSelected,
    required this.selectedPapers,
  });

  @override
  State<AddPaperBottomSheet> createState() => _AddPaperBottomSheetState();
}

class _AddPaperBottomSheetState extends State<AddPaperBottomSheet> {
  late final TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeCubit>().loadAllPapers();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesQuery(PaperEntity paper, String query) {
    if (query.trim().isEmpty) return true;
    final haystack = [
      paper.title,
      paper.abstract,
      paper.preprint,
      paper.authors.join(' '),
      paper.categories.join(' '),
    ].join(' ').toLowerCase();

    final terms = query.toLowerCase().trim().split(RegExp(r'\s+'));
    return terms.every(haystack.contains);
  }

  List<PaperEntity> _getAllPapers(HomeState state) {
    if (state is HomePapersLoaded) {
      final all = <PaperEntity>[
        ...state.recentPapers,
        ...state.recommendations,
      ];
      final byId = <String, PaperEntity>{};
      for (final paper in all) {
        byId[paper.id] = paper;
      }
      return byId.values.toList();
    }
    if (state is HomeRecentPapersLoaded) {
      return state.recentPapers;
    }
    if (state is HomeRecommendationsLoaded) {
      return state.recommendations;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight = MediaQuery.of(context).size.height * 0.92;

    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            ResponsiveHelper.responsiveValue(context, 20),
          ),
          topRight: Radius.circular(
            ResponsiveHelper.responsiveValue(context, 20),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MySizes.spaceMd(context),
                vertical: MySizes.spaceSm(context),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Paper',
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: MyColors.primaryShade900,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedCancel01,
                      size: ResponsiveHelper.responsiveValue(context, 24),
                      color: MyColors.primaryShade600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MySizes.spaceMd(context),
              ),
              child: MySearchBar(
                controller: _searchController,
                hintText: 'Search papers, authors, keywords... ',
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            SizedBox(height: MySizes.spaceMd(context)),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading || state is HomeInitial) {
                    return const PaperShimmerLoading(
                      itemCount: 5,
                      shrinkWrap: false,
                    );
                  }

                  if (state is HomeError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: context.bodyMedium.copyWith(
                          color: MyColors.primaryShade600,
                        ),
                      ),
                    );
                  }

                  final papers = _getAllPapers(
                    state,
                  ).where((paper) => _matchesQuery(paper, _query)).toList();

                  if (papers.isEmpty) {
                    return Center(
                      child: Text(
                        'No related papers found',
                        style: context.bodyMedium.copyWith(
                          color: MyColors.primaryShade600,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.only(
                      left: MySizes.spaceMd(context),
                      right: MySizes.spaceMd(context),
                      bottom: MySizes.spaceLg(context),
                    ),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: MySizes.spaceMd(context)),
                    itemCount: papers.length,
                    itemBuilder: (context, index) {
                      final paper = papers[index];
                      final isSelected = widget.selectedPapers.any(
                        (selected) => selected.id == paper.id,
                      );

                      return GestureDetector(
                        onTap: isSelected
                            ? null
                            : () {
                                widget.onPaperSelected(paper);
                                Navigator.pop(context);
                              },
                        child: Stack(
                          children: [
                            AbsorbPointer(
                              child: PaperCard(
                                paper: paper,
                                onTap: () {
                                  context.push(RouteNames.paperDetailsRoute(paper.id), extra: paper);
                                },
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                top: ResponsiveHelper.responsiveValue(
                                  context,
                                  12,
                                ),
                                right: ResponsiveHelper.responsiveValue(
                                  context,
                                  12,
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        ResponsiveHelper.responsiveValue(
                                          context,
                                          8,
                                        ),
                                    vertical: ResponsiveHelper.responsiveValue(
                                      context,
                                      4,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: MyColors.primaryShade700,
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveHelper.responsiveValue(
                                        context,
                                        8,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Added',
                                    style: context.bodySmall.copyWith(
                                      color: MyColors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          ResponsiveHelper.responsiveValue(
                                            context,
                                            10,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
