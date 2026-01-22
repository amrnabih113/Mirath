import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/my_loaders.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mirath/features/interests/presentation/widgets/interests_chip.dart';
import 'package:mirath/features/common/widgets/my_search_bar.dart';
import 'package:mirath/features/common/widgets/screen_decoration.dart';
import 'package:mirath/features/interests/domain/entities/interest.dart';
import 'package:mirath/features/interests/presentation/cubit/interests_cubit.dart';
import 'package:mirath/features/interests/presentation/cubit/interests_state.dart';
import 'package:mirath/features/users/domain/entities/profile_setup_data.dart';
import 'package:mirath/injection/injection_container.dart';

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
    return BlocProvider.value(
      value: _interestsCubit,
      child: Scaffold(
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
                                    _buildInterestsSection(),
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
                  _buildBottomButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInterestsSection() {
    return BlocBuilder<InterestsCubit, InterestsState>(
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
                  Text('Error loading interests', style: context.bodyLarge),
                  SizedBox(height: MySizes.spaceSm(context)),
                  ElevatedButton(
                    onPressed: () {
                      _interestsCubit.getAllInterests();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is InterestsLoaded) {
          return _buildInterestsList(state.interests);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInterestsList(List<Interest> interests) {
    return _searchController.text.isEmpty
        ? SizedBox(
            height: MySizes.screenHeight(context) * 0.4,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: MySizes.spaceXs(context),
                runSpacing: MySizes.spaceMd(context),
                children: _selectedInterests
                    .map(
                      (interest) => InterestsChip(
                        interest: interest,
                        onDeleted: () {
                          setState(() {
                            _selectedInterests.remove(interest);
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
              final filteredInterests = interests
                  .where(
                    (interest) => !_selectedInterests.contains(interest.name),
                  )
                  .where(
                    (interest) => interest.name.toLowerCase().contains(
                      _searchController.text.toLowerCase(),
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
                        setState(() {
                          _selectedInterests.add(interest.name);
                          _searchController.clear();
                        });
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

  Widget _buildBottomButton() {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          // Show success message
          MyLoaders.successSnackBar(
            context: context,
            title: 'Success',
            message: 'Profile set up successfully!',
          );
          // Small delay to show the success message then navigate
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) {
              context.go('/home');
            }
          });
        } else if (state.status == AuthStatus.error) {
          // Show error message
          MyLoaders.errorSnackBar(
            context: context,
            title: 'Error',
            message: state.message ?? 'Profile setup failed',
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state.status == AuthStatus.loading;
          return SizedBox(
            width: MySizes.buttonWidth(context),
            child: ElevatedButton(
              onPressed: _selectedInterests.isEmpty || isLoading
                  ? null
                  : () {
                      context.read<AuthCubit>().setUpProfile(
                        widget.userProfile.copyWith(
                          interests: _selectedInterests,
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: MySizes.spaceMd(context),
                  horizontal: MySizes.spaceLg(context),
                ),
              ),
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
                        color: MyColors.light,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
