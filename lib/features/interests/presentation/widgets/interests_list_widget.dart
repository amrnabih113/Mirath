import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../domain/entities/interest.dart';
import 'interests_chip.dart';

class InterestsListWidget extends StatelessWidget {
  final List<Interest> interests;
  final TextEditingController searchController;
  final List<String> selectedInterests;
  final VoidCallback onInterestsUpdated;

  const InterestsListWidget({
    super.key,
    required this.interests,
    required this.searchController,
    required this.selectedInterests,
    required this.onInterestsUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return searchController.text.isEmpty
        ? SizedBox(
            height: MySizes.screenHeight(context) * 0.4,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: MySizes.spaceXs(context),
                runSpacing: MySizes.spaceMd(context),
                children: selectedInterests
                    .map(
                      (interest) => InterestsChip(
                        interest: interest,
                        onDeleted: () {
                          selectedInterests.remove(interest);
                          onInterestsUpdated();
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          )
        : LayoutBuilder(
            builder: (context, constraints) {
              final filteredInterests = interests
                  .where(
                    (interest) => !selectedInterests.contains(interest.name),
                  )
                  .where(
                    (interest) => interest.name.toLowerCase().contains(
                      searchController.text.toLowerCase(),
                    ),
                  )
                  .toList();

              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MySizes.screenHeight(context) * 0.4,
                  maxWidth: 600,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredInterests.length,
                  itemBuilder: (context, index) {
                    final interest = filteredInterests[index];
                    return ListTile(
                      minTileHeight: 0,
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        selectedInterests.add(interest.name);
                        searchController.clear();
                        onInterestsUpdated();
                      },
                      title: Text(interest.name, style: context.bodyLarge),
                      trailing: HugeIcon(
                        size: MySizes.iconSmall(context),
                        icon: HugeIcons.strokeRoundedAddCircle,
                      ),
                    );
                  },
                ),
              );
            },
          );
  }
}
