import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/ui/widgets/my_app_bar.dart';
import 'package:mirath/core/ui/widgets/my_body.dart';

import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';
import '../cubit/library_cubit.dart';
import '../../../../core/constants/route_names.dart';
import '../widgets/lib_tiles.dart';
import '../widgets/my_item.dart';
import '../widgets/my_item_shimmer.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text(
          S.of(context).your_library,
          style: context.headlineLarge.copyWith(
            color: Colors.black,
            fontSize: ResponsiveHelper.responsiveValue(context, 20),
          ),
        ),
      ),
      body: MyBody(
        padding: MySizes.paddingMd(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BlocBuilder<LibraryCubit, LibraryState>(
              builder: (context, state) {
                if (state is LibraryDataLoading) {
                  return const MyItemShimmer();
                } else if (state is LibraryDataSuccess) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.fromCache)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.responsiveValue(
                              context,
                              12,
                            ),
                            vertical: ResponsiveHelper.responsiveValue(
                              context,
                              8,
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.responsiveValue(context, 8),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.wifi_off_rounded,
                                size: ResponsiveHelper.responsiveValue(
                                  context,
                                  18,
                                ),
                              ),
                              SizedBox(
                                width: ResponsiveHelper.responsiveValue(
                                  context,
                                  8,
                                ),
                              ),
                              Text(
                                'Showing cached data',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      if (state.fromCache)
                        SizedBox(height: MySizes.spaceSm(context)),
                      MyItem(data: state.libraryData),
                    ],
                  );
                } else if (state is LibraryDataFailure) {
                  return Text('Error: ${state.errorMessage}');
                } else {
                  return const SizedBox();
                }
              },
            ),
            SizedBox(height: MySizes.spaceLg(context) * 1.25),
            LibTiles(
              title: "Read Later", //S.of(context).reading_later,
              onTap: () {
                context.push(RouteNames.readLater);
              },
            ),
            SizedBox(height: MySizes.spaceMd(context)),
            LibTiles(
              title: S.of(context).projects,
              onTap: () {
                context.push(RouteNames.projects);
              },
            ),
            SizedBox(height: MySizes.spaceMd(context)),
            LibTiles(
              title: S.of(context).reading_lists,
              onTap: () {
                context.push(RouteNames.readingLists);
              },
            ),
            SizedBox(height: MySizes.spaceMd(context)),
            LibTiles(
              title: S.of(context).reading_history,
              onTap: () {
                context.push(RouteNames.readingHistory);
              },
            ),
          ],
        ),
      ),
    );
  }
}
