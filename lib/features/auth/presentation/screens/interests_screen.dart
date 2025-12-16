import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/auth/domain/entities/user_profile.dart';
import 'package:mirath/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mirath/features/auth/presentation/widgets/intereste_chip.dart';
import 'package:mirath/features/common/widgets/my_search_bar.dart';
import 'package:mirath/features/common/widgets/screen_decoration.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key, required this.userProfile});
  final UserProfile userProfile;

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<String> _allInterests = [
    'Artificial Intelligence',
    'Machine Learning',
    'Data Science',
    'Web Development',
    'Mobile Development',
    'Cloud Computing',
    'Cybersecurity',
    'Blockchain',
    'Internet of Things',
    'Virtual Reality',
    'Augmented Reality',
    'Game Development',
    'DevOps',
    'UI/UX Design',
    'Big Data',
    'Quantum Computing',
    'Natural Language Processing',
    'Computer Vision',
    'Robotics',
    'Software Testing',
    'Agile Methodologies',
    'Project Management',
    'Database Management',
    'Networking',
    'Operating Systems',
    'Programming Languages',
    'Data Analytics',
    'E-commerce',
    'Digital Marketing',
    'SEO',
    'Content Creation',
  ];
  final List<String> _selectedInterests = [];
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

                                  _searchController.text.isEmpty
                                      ? SizedBox(
                                          height:
                                              MySizes.screenHeight(context) *
                                              0.4,
                                          child: SingleChildScrollView(
                                            child: Wrap(
                                              spacing: MySizes.spaceXs(context),
                                              runSpacing: MySizes.spaceMd(
                                                context,
                                              ),
                                              children: _selectedInterests
                                                  .map(
                                                    (interest) => InteresteChip(
                                                      interest: interest,
                                                      onDeleted: () {
                                                        setState(() {
                                                          _selectedInterests
                                                              .remove(interest);
                                                        });
                                                      },
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        )
                                      : LayoutBuilder(
                                          builder: (context, constraints) {
                                            return ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxHeight:
                                                    MySizes.screenHeight(
                                                      context,
                                                    ) *
                                                    0.4,
                                                maxWidth: 600,
                                              ),
                                              child: ListView(
                                                shrinkWrap: true,
                                                children:
                                                    (_allInterests
                                                            .toSet()
                                                            .difference(
                                                              _selectedInterests
                                                                  .toSet(),
                                                            ))
                                                        .toList()
                                                        .where(
                                                          (interest) => interest
                                                              .toLowerCase()
                                                              .contains(
                                                                _searchController
                                                                    .text
                                                                    .toLowerCase(),
                                                              ),
                                                        )
                                                        .map(
                                                          (
                                                            interest,
                                                          ) => ListTile(
                                                            minTileHeight: 0,
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            onTap: () {
                                                              setState(() {
                                                                _selectedInterests
                                                                    .add(
                                                                      interest,
                                                                    );
                                                                _searchController
                                                                    .clear();
                                                              });
                                                            },
                                                            title: Text(
                                                              interest,
                                                              style: context
                                                                  .bodyLarge,
                                                            ),
                                                            trailing: HugeIcon(
                                                              size:
                                                                  MySizes.iconSmall(
                                                                    context,
                                                                  ),
                                                              icon: HugeIcons
                                                                  .strokeRoundedAddCircle,
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                              ),
                                            );
                                          },
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

                /// 🔹 Fixed Bottom Button
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state.status == AuthStatus.loading;
                    return SizedBox(
                      width: MySizes.buttonWidth(context),
                      child: ElevatedButton(
                        onPressed: _selectedInterests.isEmpty
                            ? null
                            : () {
                                context.read<AuthCubit>().setUpProfile(
                                  widget.userProfile.copyWith(
                                    interests: _selectedInterests,
                                  ),
                                );
                                context.go('/home');
                                
                              },

                        child: isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    MyColors.primaryShade50,
                                  ),
                                ),
                              )
                            : Text(
                                'Next',
                                style: context.titleMedium.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
