import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../injection/injection_container.dart';
import '../../../../core/services/user_cache_service.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../../common/widgets/profile_avatar.dart';
import '../../../common/widgets/tag_chip.dart';
import '../../../home/presentation/widgets/paper_card.dart';
import '../../domain/entities/reading_list.dart';
import '../../../home/domain/entities/paper_entity.dart';
import '../../../users/domain/entities/user.dart';
import '../../../users/domain/usecases/get_user_profile_header_usecase.dart';
import '../cubit/reading_list_cubit.dart';
import '../cubit/reading_list_state.dart';
import '../widgets/reading_list_details_shimmer_loading.dart';

class ReadingListDetailsScreen extends StatefulWidget {
  final ReadingList readingList;

  const ReadingListDetailsScreen({super.key, required this.readingList});

  @override
  State<ReadingListDetailsScreen> createState() =>
      _ReadingListDetailsScreenState();
}

class _ReadingListDetailsScreenState extends State<ReadingListDetailsScreen> {
  late ReadingListCubit _cubit;
  User? _ownerProfile;

  @override
  void initState() {
    super.initState();
    _cubit = sl<ReadingListCubit>();
    _cubit.getReadingListById(widget.readingList.id);
    _loadOwnerProfile();
  }

  Future<void> _loadOwnerProfile() async {
    final result = await sl<GetUserProfileHeaderUsecase>()(
      widget.readingList.ownerId,
    );

    result.fold((_) {}, (user) {
      if (!mounted) return;
      setState(() => _ownerProfile = user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ResponsiveHelper.responsiveValue(context, 50),
        leadingWidth: ResponsiveHelper.responsiveValue(context, 50),
        leading: const MyBackIcon(),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: MySizes.spaceSm(context)),
            child: IconButton(
              onPressed: () {},
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedMoreHorizontal,
                size: MySizes.iconMedium(context),
                strokeWidth: ResponsiveHelper.responsiveValue(context, 2),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _cubit,
        child: BlocBuilder<ReadingListCubit, ReadingListState>(
          builder: (context, state) {
            if (state is ReadingListLoading) {
              return const ReadingListDetailsShimmerLoading();
            }

            if (state is ReadingListError) {
              return Center(child: Text(state.message));
            }

            if (state is ReadingListDetailsLoaded) {
              final readingList = state.readingList;
              return _buildContent(context, readingList);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ReadingList readingList) {
    final cachedUser = sl<UserCacheService>().getCachedUser();
    final isOwner = cachedUser?.id == readingList.ownerId;
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
                            imageUrl:
                                _ownerProfile?.photoUrl ??
                                _buildOwnerAvatarUrl(readingList),
                          ),
                          SizedBox(width: MySizes.spaceSm(context)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _ownerProfile?.fullName ??
                                      readingList.owner?.fullName ??
                                      'Unknown',
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
                          onPressed: () {},
                          child: const Text('Save Full List'),
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
                            child: PaperCard(number: index + 1, paper: paper),
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

String? _buildOwnerAvatarUrl(ReadingList readingList) {
  final username = readingList.owner?.username;
  if (username == null || username.trim().isEmpty) {
    return null;
  }
  return 'https://github.com/$username.png?size=200';
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
              publishedAt: paper.paper!.publishedAt.toIso8601String(),
              authors: paper.paper!.authors,
              categories: paper.paper!.categories,
              isSaved: true,
              preprint: paper.paper!.citation,
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
