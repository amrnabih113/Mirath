import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/discussions/presentation/cubit/community_cubit.dart';
import 'package:mirath/features/discussions/presentation/cubit/community_state.dart';
import 'package:mirath/features/discussions/presentation/widgets/discussion_card.dart';
import 'package:mirath/features/home/domain/entities/paper_entity.dart';
import 'package:mirath/generated/l10n.dart';

class PaperDiscussionsScreen extends StatefulWidget {
  final PaperEntity paper;

  const PaperDiscussionsScreen({super.key, required this.paper});

  @override
  State<PaperDiscussionsScreen> createState() => _PaperDiscussionsScreenState();
}

class _PaperDiscussionsScreenState extends State<PaperDiscussionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CommunityCubit>().getDiscussions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          ResponsiveHelper.responsiveValue(context, 50),
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: AppBar(
                  leadingWidth: ResponsiveHelper.responsiveValue(context, 50),
                  leading: MyBackIcon(),
                  titleSpacing: 0,
                  title: Text(
                    S.of(context).discussions_label,
                    style: context.titleMedium,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: BlocBuilder<CommunityCubit, CommunityState>(
                builder: (context, state) {
                  if (state is CommunityLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CommunityError) {
                    return Center(
                      child: Text(state.message, style: context.bodyMedium),
                    );
                  }

                  if (state is CommunityDiscussionsLoaded) {
                    final discussions = state.discussions
                        .where(
                          (d) => d.papers.any((p) => p.id == widget.paper.id),
                        )
                        .toList();

                    if (discussions.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No discussions yet',
                              style: context.titleMedium,
                            ),
                            SizedBox(height: MySizes.spaceSm(context)),
                            Text(
                              'Be the first to start a discussion about this paper',
                              style: context.bodyMedium.copyWith(
                                color: MyColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: MySizes.spaceMd(context)),
                            ElevatedButton(
                              onPressed: () {
                                context.push(
                                  '/add-discussion',
                                  extra: widget.paper,
                                );
                              },
                              child: Text(
                                S.of(context).start_discussion_button,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Padding(
                      padding: MySizes.paddingMd(context),
                      child: ListView.separated(
                        itemCount: discussions.length,
                        separatorBuilder: (_, _) =>
                            SizedBox(height: MySizes.spaceMd(context)),
                        itemBuilder: (context, index) {
                          final discussion = discussions[index];
                          return DiscussionCard(
                            discussion: discussion,
                            onTap: () {
                              context.push(
                                '/discussion-details',
                                extra: discussion,
                              );
                            },
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
