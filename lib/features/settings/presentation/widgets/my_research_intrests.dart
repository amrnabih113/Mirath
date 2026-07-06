import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/features/common/widgets/tag_chip.dart';
import 'package:mirath/features/settings/domain/entities/research_interests_entitiy.dart';
import 'package:mirath/features/settings/presentation/cubit/settings_cubit.dart';

class MyResearchIntrests extends StatelessWidget {
  const MyResearchIntrests({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My research interests',
            style: context.labelLarge.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text('Can be different from interests on the profiles'),

          const SizedBox(height: 8),
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              if (state is SettingsLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is SettingsSuccess<List<ResearchInterestsEntitiy>>) {
                final List<ResearchInterestsEntitiy> data = state.data;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ...data.map(
                      (item) => TagChip(label: item.name, hasIcon: true),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        context.read<SettingsCubit>().replaceResearchInterests(
                          interests: data,
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        backgroundColor: MyColors.primaryShade200,
                        minimumSize: const Size(0, 28),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        side: const BorderSide(color: Colors.black),
                      ),
                      icon: const Icon(
                        Icons.add,
                        color: MyColors.black,
                        size: 25,
                      ),
                      label: Text(
                        'Add interest',
                        style: context.labelLarge.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: MyColors.black,
                        ),
                      ),
                    ),
                  ],
                );
              }
              if (state is SettingsFailure) {
                return Center(child: Text(state.errormessage));
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
