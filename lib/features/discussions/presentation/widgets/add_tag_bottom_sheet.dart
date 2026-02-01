import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_search_bar.dart';
import 'package:mirath/features/interests/domain/entities/interest.dart';
import 'package:mirath/features/interests/presentation/cubit/interests_cubit.dart';
import 'package:mirath/features/interests/presentation/cubit/interests_state.dart';

class AddTagBottomSheet extends StatefulWidget {
  final Function(String, String) onTagSelected; // id, name
  final List<String> selectedTags; // Tag names only

  const AddTagBottomSheet({
    super.key,
    required this.onTagSelected,
    required this.selectedTags,
  });

  @override
  State<AddTagBottomSheet> createState() => _AddTagBottomSheetState();
}

class _AddTagBottomSheetState extends State<AddTagBottomSheet> {
  late final TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesQuery(Interest interest, String query) {
    if (query.trim().isEmpty) return true;
    return interest.name.toLowerCase().contains(query.toLowerCase().trim());
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
                    'Add Tag',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tags help your discussion reach more people (${widget.selectedTags.length}/5)',
                    style: context.bodySmall.copyWith(
                      color: MyColors.primaryShade600,
                    ),
                  ),
                  SizedBox(height: MySizes.spaceSm(context)),
                  MySearchBar(
                    controller: _searchController,
                    hintText: 'Search topics (e.g. Computer Science)',
                    onChanged: (value) => setState(() => _query = value),
                  ),
                ],
              ),
            ),
            SizedBox(height: MySizes.spaceMd(context)),
            Expanded(
              child: BlocBuilder<InterestsCubit, InterestsState>(
                builder: (context, state) {
                  if (state is InterestsLoading || state is InterestsInitial) {
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: MySizes.spaceMd(context),
                      ),
                      separatorBuilder: (context, index) =>
                          Divider(height: 1, color: MyColors.primaryShade200),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: MyColors.primaryShade100,
                          highlightColor: MyColors.primaryShade50,
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: MySizes.spaceSm(context),
                              vertical: 0,
                            ),
                            leading: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: MyColors.primaryShade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            title: Container(
                              height: 16,
                              width: 150,
                              decoration: BoxDecoration(
                                color: MyColors.primaryShade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            trailing: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: MyColors.primaryShade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  if (state is InterestsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            style: context.bodyMedium.copyWith(
                              color: MyColors.primaryShade600,
                            ),
                          ),
                          SizedBox(height: MySizes.spaceMd(context)),
                          ElevatedButton(
                            onPressed: () {
                              context.read<InterestsCubit>().getAllInterests();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is InterestsLoaded) {
                    final interests = state.interests
                        .where((interest) => _matchesQuery(interest, _query))
                        .toList();

                    if (interests.isEmpty) {
                      return Center(
                        child: Text(
                          'No tags found',
                          style: context.bodyMedium.copyWith(
                            color: MyColors.primaryShade600,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: MySizes.spaceMd(context),
                      ),
                      separatorBuilder: (context, index) =>
                          Divider(height: 1, color: MyColors.primaryShade200),
                      itemCount: interests.length,
                      itemBuilder: (context, index) {
                        final interest = interests[index];
                        final isSelected = widget.selectedTags.any(
                          (tag) => tag == interest.name,
                        );
                        final canSelect =
                            !isSelected && widget.selectedTags.length < 5;

                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: MySizes.spaceSm(context),
                            vertical: 0,
                          ),
                          leading: HugeIcon(
                            icon: HugeIcons.strokeRoundedTag01,
                            size: ResponsiveHelper.responsiveValue(context, 24),
                            color: isSelected
                                ? MyColors.primaryShade400
                                : MyColors.primaryShade700,
                          ),
                          title: Text(
                            interest.name,
                            style: context.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? MyColors.primaryShade400
                                  : MyColors.primaryShade900,
                            ),
                          ),
                          trailing: isSelected
                              ? HugeIcon(
                                  icon:
                                      HugeIcons.strokeRoundedCheckmarkCircle02,
                                  size: ResponsiveHelper.responsiveValue(
                                    context,
                                    24,
                                  ),
                                  color: MyColors.primaryColor,
                                )
                              : null,
                          onTap: isSelected || !canSelect
                              ? null
                              : () {
                                  widget.onTagSelected(
                                    interest.id,
                                    interest.name,
                                  );
                                  Navigator.pop(context);
                                },
                          enabled: canSelect || isSelected,
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
