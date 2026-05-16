import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';
import '../cubit/interests_cubit.dart';
import '../cubit/interests_state.dart';
import 'interests_list_widget.dart';

class InterestsSectionWidget extends StatelessWidget {
  final InterestsCubit interestsCubit;
  final TextEditingController searchController;
  final List<String> selectedInterests;
  final VoidCallback onInterestsUpdated;

  const InterestsSectionWidget({
    super.key,
    required this.interestsCubit,
    required this.searchController,
    required this.selectedInterests,
    required this.onInterestsUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InterestsCubit, InterestsState>(
      bloc: interestsCubit,
      builder: (context, state) {
        if (state is InterestsLoading) {
          return SizedBox(
            height: MySizes.screenHeight(context) * 0.4,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is InterestsError) {
          return SizedBox(
            height: MySizes.screenHeight(context) * 0.4,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).error_loading_interests,
                    style: context.bodyLarge,
                  ),
                  SizedBox(height: MySizes.spaceSm(context)),
                  ElevatedButton(
                    onPressed: () {
                      interestsCubit.getAllInterests();
                    },
                    child: Text(S.of(context).retry_button),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is InterestsLoaded) {
          return InterestsListWidget(
            interests: state.interests,
            searchController: searchController,
            selectedInterests: selectedInterests,
            onInterestsUpdated: onInterestsUpdated,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
