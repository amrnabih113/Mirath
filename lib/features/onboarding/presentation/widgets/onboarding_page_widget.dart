import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../domain/entities/onboarding_entity.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingEntity page;

  const OnboardingPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    // Scale image and spacing based on height
    final imageHeight =
        MySizes.imageLarge(context) * (height / 800).clamp(0.7, 1.0);
    final spacing = MySizes.spaceMd(context) * (height / 800).clamp(0.5, 1.0);

    return Padding(
      padding: MySizes.paddingLg(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Flexible(
            flex: 4,
            child: SvgPicture.asset(
              page.imagePath,
              height: imageHeight,
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(height: spacing),

          // Title
          Flexible(
            flex: 2,
            child: Text(
              page.title,
              style: context.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: spacing / 2),

          // Description
          Flexible(
            flex: 2,
            child: Text(
              page.description,
              style: context.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
