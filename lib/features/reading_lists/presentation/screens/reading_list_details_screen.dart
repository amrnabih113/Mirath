import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mirath/core/utils/my_logger.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../../common/widgets/profile_avatar.dart';
import '../../../common/widgets/tag_chip.dart';
import '../../../home/presentation/widgets/paper_card.dart';
import '../../domain/entities/reading_list.dart';
import '../../../home/domain/entities/paper_entity.dart';
import '../cubit/reading_list_cubit.dart';
import '../cubit/reading_list_state.dart';
import '../widgets/reading_list_details_shimmer_loading.dart';

class ReadingListDetailsScreen extends StatefulWidget {
  final ReadingList? readingList;

  const ReadingListDetailsScreen({super.key, this.readingList});

  @override
  State<ReadingListDetailsScreen> createState() =>
      _ReadingListDetailsScreenState();
}

class _ReadingListDetailsScreenState extends State<ReadingListDetailsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.readingList != null) {
      MyLogger.debug(
        'ReadingListDetailsScreen initialized with reading list ID: ${widget.readingList!.id}',
      );
    } else {
      MyLogger.debug(
        'ReadingListDetailsScreen initialized without reading list object',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingListCubit, ReadingListState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: ResponsiveHelper.responsiveValue(context, 50),
            leadingWidth: ResponsiveHelper.responsiveValue(context, 50),
            leading: const MyBackIcon(),
            titleSpacing: 0,
          ),
          body: Builder(
            builder: (context) {
              if (state is ReadingListLoading) {
                return const ReadingListDetailsShimmerLoading();
              }

              if (state is ReadingListError) {
                return Center(child: Text(state.message));
              }

              if (state is ReadingListDetailsLoaded) {
                return _buildContent(context, state.readingList);
              }

              return const SizedBox();
            },
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ReadingList readingList) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Padding(
              padding: MySizes.paddingMd(context),
              child: SafeArea(
                bottom: false,
                child: CustomScrollView(
                  slivers: [
                    /// USER HEADER
                    SliverToBoxAdapter(
                      child: Row(
                        children: [
                          ProfileAvatar(
                            size: ResponsiveHelper.responsiveValue(context, 40),
                            imageUrl: readingList.owner?.photoUrl,
                          ),
                          SizedBox(width: MySizes.spaceSm(context)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  readingList.owner?.fullName ?? 'Unknown',
                                  style: context.titleSmall.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(
                                  height: MySizes.spaceXs(context) * 0.5,
                                ),
                                Text(
                                  '${readingList.papers?.length ?? readingList.paperCount} papers • Updated ${_formatDate(readingList.updatedAt)}',
                                  style: context.bodySmall.copyWith(
                                    color: MyColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: MySizes.spaceMd(context)),
                    ),

                    /// TITLE
                    SliverToBoxAdapter(
                      child: Text(
                        readingList.title,
                        style: context.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: MySizes.spaceSm(context)),
                    ),

                    /// DESCRIPTION
                    if (readingList.description != null)
                      SliverToBoxAdapter(
                        child: ExpandableText(text: readingList.description!),
                      ),
                    if (readingList.description != null)
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),

                    /// TAGS
                    if (readingList.previewTags.isNotEmpty)
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: ResponsiveHelper.responsiveValue(context, 28),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: readingList.previewTags.length,
                            separatorBuilder: (_, _) =>
                                SizedBox(width: MySizes.spaceXs(context)),
                            itemBuilder: (_, index) =>
                                TagChip(label: readingList.previewTags[index]),
                          ),
                        ),
                      ),
                    if (readingList.previewTags.isNotEmpty)
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),

                    /// SAVE BUTTON
                    SliverToBoxAdapter(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final cubit = context.read<ReadingListCubit>();
                            final currentState = cubit.state;
                            final currentList =
                                currentState is ReadingListDetailsLoaded
                                ? currentState.readingList
                                : widget.readingList;

                            if (currentList == null) return;

                            if (currentList.isSaved) {
                              cubit.unsaveReadingList(currentList.id);
                            } else {
                              cubit.saveReadingList(currentList.id);
                            }
                          },
                          child:
                              BlocBuilder<ReadingListCubit, ReadingListState>(
                                builder: (context, state) {
                                  final isSaved =
                                      state is ReadingListDetailsLoaded
                                      ? state.readingList.isSaved
                                      : widget.readingList?.isSaved ?? false;
                                  return Text(
                                    isSaved ? 'Unsave List' : 'Save Full List',
                                  );
                                },
                              ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: MySizes.spaceLg(context)),
                    ),

                    /// PAPERS LIST
                    if (_buildPapers(readingList).isNotEmpty)
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final paper = _buildPapers(readingList)[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MySizes.spaceMd(context),
                            ),
                            child: PaperCard(
                              number: index + 1,
                              paper: paper,
                              onTap: () {},
                            ),
                          );
                        }, childCount: _buildPapers(readingList).length),
                      ),
                    if (_buildPapers(readingList).isEmpty)
                      SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            'No papers in this list yet',
                            style: context.bodyMedium.copyWith(
                              color: MyColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }
}

List<PaperEntity> _buildPapers(ReadingList readingList) {
  final papers =
      readingList.papers
          ?.where((paper) => paper.paper != null)
          .map(
            (paper) => PaperEntity(
              id: paper.paper!.id,
              title: paper.paper!.title,
              abstract: paper.paper!.abstract,
              publishedAt: paper.paper!.publishedAt,
              authors: paper.paper!.authors,
              categories: paper.paper!.categories,
              isSaved: paper.paper!.isSaved,
              preprint: paper.paper!.preprint,
              citation: paper.paper!.citation,
            ),
          )
          .toList() ??
      [];
  return papers;
}

class ExpandableText extends StatefulWidget {
  const ExpandableText({super.key, required this.text});
  final String text;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    const maxLength = 120;
    final shouldTruncate = widget.text.length > maxLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isExpanded || !shouldTruncate
              ? widget.text
              : widget.text.substring(0, maxLength),
          style: context.bodyMedium.copyWith(
            height: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (shouldTruncate)
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? 'less' : '...more',
              style: context.bodyMedium.copyWith(
                color: MyColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
