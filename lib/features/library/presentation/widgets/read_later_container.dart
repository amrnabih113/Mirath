import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/library/presentation/cubit/library_cubit.dart';
import 'package:shimmer/shimmer.dart';

class ReadLaterContainer extends StatelessWidget {
  const ReadLaterContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(RouteNames.readLater);
      },
      child: BlocBuilder<LibraryCubit, LibraryState>(
        builder: (context, state) {
          if (state is GetAllSavedPapersLoading) {
            return readLaterHeaderShimmer(context);
          } else if (state is GetAllSavedPapersFailure) {
            return Center(child: Text(state.errorMessage));
          } else if (state is GetAllSavedPapersSuccess) {
            final savedPapers = state.savedPapers;
            final formattedDate = DateFormat(
              'dd',
            ).format(savedPapers.first.createdAt);

            return Container(
              height: ResponsiveHelper.responsiveValue(context, 100),
              width: MySizes.screenWidth(context),
              padding: EdgeInsets.all(
                ResponsiveHelper.responsiveValue(context, 16),
              ),
              decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.responsiveValue(context, 16),
                ),
                border: Border.all(color: MyColors.primaryShade800, width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Read Later',
                    style: context.headlineSmall.copyWith(
                      color: MyColors.primaryShade900,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: MySizes.spaceSm(context) * 0.5),
                  Text(
                    '${savedPapers.length} papers • Updated $formattedDate days ago',
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

Widget readLaterHeaderShimmer(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      height: ResponsiveHelper.responsiveValue(context, 100),
      width: MySizes.screenWidth(context),
      padding: EdgeInsets.all(ResponsiveHelper.responsiveValue(context, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.responsiveValue(context, 16),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title shimmer
          Container(
            height: ResponsiveHelper.responsiveValue(context, 18),
            width: ResponsiveHelper.responsiveValue(context, 120),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.responsiveValue(context, 8),
              ),
            ),
          ),

          SizedBox(height: MySizes.spaceSm(context)),

          // subtitle shimmer
          Container(
            height: ResponsiveHelper.responsiveValue(context, 14),
            width: ResponsiveHelper.responsiveValue(context, 180),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.responsiveValue(context, 8),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
