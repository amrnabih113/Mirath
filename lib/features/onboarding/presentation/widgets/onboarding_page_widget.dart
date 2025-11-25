import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingEntity page;

  const OnboardingPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MySizes.paddingLg(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Center(
            child: SvgPicture.asset(
              page.imagePath,
              height: MySizes.imageXl(context),
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: MySizes.spaceXl(context) * 1.5),
          // Title
          Text(
            page.title,
            style: context.headlineLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MySizes.spaceMd(context)),
          // Description
          Text(
            page.description,
            style: context.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
