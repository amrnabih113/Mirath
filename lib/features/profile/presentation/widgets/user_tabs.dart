import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/features/discussions/domain/entities/discussion.dart';
import 'package:mirath/features/discussions/domain/entities/get_discussions_params.dart';
import 'package:mirath/features/discussions/domain/usecases/get_all_discussions_usecase.dart';
import 'package:mirath/features/discussions/presentation/cubit/community_cubit.dart';
import 'package:mirath/features/discussions/presentation/widgets/discussion_card.dart';
import 'package:mirath/features/reading_lists/presentation/widgets/reading_list_card.dart';
import 'package:mirath/features/reading_lists/domain/entities/reading_list.dart';
import 'package:mirath/features/reading_lists/domain/entities/reading_list_query_params.dart';
import 'package:mirath/features/reading_lists/domain/usecases/get_reading_lists_usecase.dart';
import 'package:mirath/generated/l10n.dart';
import 'package:mirath/injection/injection_container.dart';

class UserTabs extends StatelessWidget {
  const UserTabs({super.key, required this.userId});

  final String userId;

  Future<List<ReadingList>> _loadReadingLists() async {
    final result = await sl<GetReadingListsUseCase>()(
      ReadingListQueryParams(ownerId: userId),
    );
    return result.fold((_) => <ReadingList>[], (lists) => lists);
  }

  Future<List<Discussion>> _loadDiscussions() async {
    final result = await sl<GetAllDiscussionsUseCase>()(
      GetDiscussionsParams(authorId: userId),
    );
    return result.fold((_) => <Discussion>[], (discussions) => discussions);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: TabBarView(
        children: [
          FutureBuilder<List<ReadingList>>(
            future: _loadReadingLists(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final readingLists = snapshot.data ?? const <ReadingList>[];
              if (readingLists.isEmpty) {
                return Center(child: Text(S.of(context).no_results_found));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: readingLists.length,
                itemBuilder: (context, index) => ReadingListCard(
                  readingList: readingLists[index],
                  onTap: () {
                    context.push(
                      RouteNames.readingListDetailsRoute(readingLists[index].id),
                      extra: readingLists[index],
                    );
                  },
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 8),
              );
            },
          ),
          BlocProvider(
            create: (_) => sl<CommunityCubit>(),
            child: FutureBuilder<List<Discussion>>(
              future: _loadDiscussions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final discussions = snapshot.data ?? const <Discussion>[];
                if (discussions.isEmpty) {
                  return Center(child: Text(S.of(context).no_results_found));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: discussions.length,
                  itemBuilder: (context, index) {
                    final discussion = discussions[index];
                    return DiscussionCard(
                      discussion: discussion,
                      onTap: () {
                        context.push('/discussion-details', extra: discussion);
                      },
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
