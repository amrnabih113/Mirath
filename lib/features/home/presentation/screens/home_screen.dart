import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/features/home/presentation/cubit/home_cubit.dart';
import 'package:mirath/features/home/presentation/cubit/home_state.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/section_title.dart';
import '../widgets/category_items_list.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/paper_card.dart';
import '../widgets/welcome_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      final cubit = context.read<HomeCubit>();
      cubit.loadMoreRecommendations();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          ResponsiveHelper.responsiveValue(context, 60),
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: const WelcomeHeader(),
              );
            },
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is HomePapersLoaded) {
                final recentPapers = state.recentPapers;
                final recommendPapers = state.recommendations;
                final isLoadingMore = state.isLoadingMoreRecent;
                return ListView(
                  controller: scrollController,
                  padding: MySizes.paddingMd(context),
                  children: [
                    const HomeSearchBar(),
                    SizedBox(height: MySizes.spaceLg(context)),
                    SectionTitle(
                      title: 'Recently Published',
                      onTap: () => context.push("/recentely-published"),
                    ),
                    SizedBox(height: MySizes.spaceMd(context)),
                    const CategoryItemsList(),
                    SizedBox(height: MySizes.spaceLg(context) * 1.5),
                    SectionTitle(
                      title: 'You might also like',
                      showSeeAll: false,
                    ),
                    SizedBox(height: MySizes.spaceMd(context)),

                    ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          recommendPapers.length + (isLoadingMore ? 1 : 0),
                      separatorBuilder: (_, _) =>
                          SizedBox(height: MySizes.spaceMd(context)),
                      itemBuilder: (context, index) {
                        if (index >= recentPapers.length) {
                          return const Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return PaperCard(paper: recommendPapers[index]);
                      },
                    ),
                    SizedBox(height: MySizes.spaceLg(context)),
                  ],
                );
              }

              return const Center(child: Text('Data not loaded'));
            },
          ),
        ),
      ),
    );
  }
}
