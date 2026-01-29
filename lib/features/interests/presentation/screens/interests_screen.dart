import 'package:flutter/material.dart';

import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../injection/injection_container.dart';
import '../../../common/widgets/my_search_bar.dart';
import '../../../common/widgets/screen_decoration.dart';
import '../../../users/domain/entities/profile_setup_data.dart';
import '../cubit/interests_cubit.dart';
import '../widgets/interests_bottom_button_widget.dart';
import '../widgets/interests_section_widget.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key, required this.userProfile});
  final ProfileSetupData userProfile;

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final TextEditingController _searchController = TextEditingController();
  late InterestsCubit _interestsCubit;
  final List<String> _selectedInterests = [];

  @override
  void initState() {
    super.initState();
    _interestsCubit = sl<InterestsCubit>();
    _interestsCubit.getAllInterests();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _interestsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ScreenDecoration(
        dark: false,
        child: SafeArea(
          child: Padding(
            padding: MySizes.paddingLg(context),
            child: Column(
              children: [
                /// 🔹 Scrollable Content
                Expanded(
                  child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Text(
                        'Define your interests',
                        style: context.headlineLarge.copyWith(
                          fontSize: MySizes.headlineLarge(context) * 1.5,
                          color: MyColors.primaryShade900,
                        ),
                      ),
                      SizedBox(height: MySizes.spaceSm(context)),
                      Text(
                        'Search for topics to personalize your recommendation feed and highlight your expertise on your profile.',
                        style: context.bodyLarge,
                      ),
                      SizedBox(height: MySizes.spaceLg(context)),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 850),
                              child: Column(
                                children: [
                                  MySearchBar(
                                    controller: _searchController,
                                    hintText:
                                        'Search a topic (e.g. Computer Science)',
                                    onChanged: (_) => setState(() {}),
                                  ),
                                  SizedBox(height: MySizes.spaceLg(context)),
                                  InterestsSectionWidget(
                                    interestsCubit: _interestsCubit,
                                    searchController: _searchController,
                                    selectedInterests: _selectedInterests,
                                    onInterestsUpdated: () => setState(() {}),
                                  ),
                                  SizedBox(height: MySizes.spaceLg(context)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                InterestsBottomButtonWidget(
                  selectedInterests: _selectedInterests,
                  userProfile: widget.userProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
