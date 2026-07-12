import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mirath/core/ui/widgets/my_app_bar.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_enums.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/settings/domain/entities/reading_and_appearance_entitiy.dart';
import 'package:mirath/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mirath/features/settings/presentation/widgets/color_palette.dart';
import 'package:mirath/features/settings/presentation/widgets/reading_tile.dart';

class ReadingAppearance extends StatelessWidget {
  const ReadingAppearance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: MyBackIcon(),
        title: Text(
          'Reading & Appearance',
          style: context.labelLarge.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is SettingsSuccess<ReadingAndAppearanceEntitiy>) {
            final data = state.data;
            return Padding(
              padding: MySizes.paddingMd(context),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Display & Appearance',
                      style: context.bodyLarge.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    ReadingTile<ColorMode>(
                      title: 'Color mode',
                      itemLabel: (mode) => mode.label,
                      selectedValue: data.colorMode,
                      items: ColorMode.values,
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<SettingsCubit>()
                              .updateThemeFontDisplayPreference(
                                mode: value,
                                size: data.defaultFontSize,
                              );
                        }
                      },
                    ),
                    Divider(color: MyColors.darkGrey, thickness: 1),
                    ReadingTile<FontSize>(
                      title: 'Default paper font size',
                      selectedValue: data.defaultFontSize,
                      itemLabel: (mode) => mode.label,
                      items: FontSize.values.toList(),
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<SettingsCubit>()
                              .updateThemeFontDisplayPreference(
                                mode: data.colorMode,
                                size: value,
                              );
                        }
                      },
                    ),
                    Divider(color: MyColors.darkGrey, thickness: 1),
                    Text(
                      'Reading & Annotations',
                      style: context.bodyLarge.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    ReadingTile<Visible>(
                      title: 'Default reading list visibility',
                      selectedValue: data.defaultReadingListVisibility,
                      itemLabel: (mode) => mode.label,
                      items: Visible.values,
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<SettingsCubit>()
                              .updateVisibilityAndAnnotation(
                                visMode: value,
                                annotationColors:
                                    data.annotationHighlightColors,
                              );
                        }
                      },
                    ),
                    Divider(color: MyColors.darkGrey, thickness: 1),
                    Text(
                      'Annotation highlight colors',
                      style: context.bodyLarge.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Default colors applied when you highlight text',
                      style: context.bodyLarge.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: MyColors.darkerGrey,
                      ),
                    ),
                    SizedBox(height: 16),
                    ColorPalette(),
                  ],
                ),
              ),
            );
          }
          if (state is SettingsFailure) {
            return Center(child: Text(state.errormessage));
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
