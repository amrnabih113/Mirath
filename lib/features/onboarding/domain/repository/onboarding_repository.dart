import 'package:flutter/material.dart';
import 'package:mirath/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:mirath/generated/l10n.dart';

import '../../../../core/utils/my_images.dart';

class OnboardingRepository {
  OnboardingRepository._();

  static List<OnboardingEntity> getData(BuildContext context) {
    return [
      OnboardingEntity(
        title: S.of(context).onboarding_title_1,
        description: S.of(context).onboarding_description_1,
        imagePath: MyImages.onboarding1,
      ),
      OnboardingEntity(
        title: S.of(context).onboarding_title_2,
        description: S.of(context).onboarding_description_2,
        imagePath: MyImages.onboarding2,
      ),
      OnboardingEntity(
        title: S.of(context).onboarding_title_3,
        description: S.of(context).onboarding_description_3,
        imagePath: MyImages.onboarding3,
      ),
    ];
  }
}
