import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/network/network_manager.dart';
import 'package:mirath/core/ui/widgets/my_app_bar.dart';
import 'package:mirath/core/ui/widgets/state_views.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mirath/features/settings/domain/entities/all_active_session_entity.dart';
import 'package:mirath/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mirath/features/settings/presentation/widgets/account_tiles.dart';
import 'package:mirath/features/settings/presentation/widgets/dialogs.dart';
import 'package:mirath/features/settings/presentation/widgets/special_text.dart';
import 'package:mirath/features/users/domain/entities/user.dart';

class AccountSecurity extends StatelessWidget {
  const AccountSecurity({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is SettingsSuccess<String>) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.data)));
        }
      },
      child: Scaffold(
        appBar: MyAppBar(
          leading: MyBackIcon(),
          title: Text(
            'Account & Security',
            style: context.labelLarge.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: MySizes.paddingMd(context),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Settings',
                  style: context.bodyLarge.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoading || state is ProfileInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is ProfileFailure) {
                      final offline =
                          !NetworkManager.instance.currentConnectionStatus;
                      return offline
                          ? OfflineStateView(
                              title: 'Offline',
                              message: state.message,
                              actionLabel: 'Retry',
                              onAction: () => context
                                  .read<ProfileCubit>()
                                  .loadCurrentUser(forceRefresh: true),
                            )
                          : ErrorStateView(
                              title: 'Error',
                              message: state.message,
                              actionLabel: 'Retry',
                              onAction: () => context
                                  .read<ProfileCubit>()
                                  .loadCurrentUser(forceRefresh: true),
                            );
                    }
                    User userData;
                    if (state is ProfileLoadSuccess) {
                      userData = state.user;
                      return AccountSettings(data: userData);
                    } else if (state is ProfileUpdateSuccess) {
                      userData = state.user;
                      return AccountSettings(data: userData);
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                Divider(color: MyColors.grey, thickness: 2),
                Text(
                  'Linked accounts',
                  style: context.bodyLarge.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                BlocListener<SettingsCubit, SettingsState>(
                  listener: (context, state) {
                    if (state is SettingsSuccess<String>) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.data)));
                    }
                  },
                  child: Builder(
                    builder: (context) {
                      final cubit = context.watch<SettingsCubit>();
                      return AccountTiles(
                        icon: HugeIcons.strokeRoundedGoogle,
                        title: 'Google',
                        subtitle: 'Sign in with your Google account',
                        onTap: () async {
                          if (cubit.isGoogleConnected) {
                            await cubit.disconnectGoogleAccount();
                          } else {
                            await context.read<AuthCubit>().signInWithGoogle();
                            cubit.updateGoogleConnectionStatus(true);
                          }
                        },
                        btnName: cubit.isGoogleConnected
                            ? 'Disconnect'
                            : 'Connect',
                        isClicked: !cubit.isGoogleConnected,
                      );
                    },
                  ),
                ),
                Divider(color: MyColors.grey, thickness: 2),

                AccountTiles(
                  icon: HugeIcons.strokeRoundedApple,
                  title: 'Apple',
                  subtitle: 'Sign in with your Apple account',
                  onTap: () {},
                  btnName: 'Connect',
                  isClicked: true,
                ),

                Divider(color: MyColors.grey, thickness: 2),
                Text(
                  'Security & Login',
                  style: context.bodyLarge.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                AccountTiles(
                  title: 'Two-factor authentication',
                  subtitleWidget: SpecialText(
                    text: 'Add a second verification step',
                    addText: 'Recommended',
                    style: context.bodyLarge.copyWith(
                      fontSize: 14,
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {},
                  btnName: 'Enable',
                  isClicked: true,
                ),

                Divider(color: MyColors.grey, thickness: 2),
                Text(
                  'Active sessions',
                  style: context.bodyLarge.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, state) {
                    if (state is SettingsLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state
                        is SettingsSuccess<List<AllActiveSessionEntity>>) {
                      final data = state.data;
                      return LoggedDevices(sessions: data);
                    }
                    if (state is SettingsFailure) {
                      return Center(child: Text(state.errormessage));
                    }
                    return SizedBox.shrink();
                  },
                ),
                Divider(color: MyColors.grey, thickness: 2),
                AccountTiles(
                  title: 'Log out of all other sessions',
                  subtitle: 'Log out of all session except current one',
                  onTap: () {
                    showLogoutDialog(
                      context,
                      title: 'Log out all other sessions?',
                      content:
                          'You will remain logged in on this device, but will be securely signed out everywhere else.',
                      fTextBtn: 'Log out all',
                      sTextBtn: 'Cancel',
                      ontap: () {
                        context
                            .read<SettingsCubit>()
                            .revokeAllActiveSessionsExceptCurrent();
                        context.pop(context);
                      },
                    );
                  },
                  btnName: 'Log out all',
                  textColor: MyColors.error,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeviceLocation extends StatelessWidget {
  const DeviceLocation({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HugeIcon(
          icon: HugeIcons.strokeRoundedUserTime01,
          size: MySizes.iconSmall(context) * .8,
        ),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            title,
            style: context.bodyLarge.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xff333333),
            ),
          ),
        ),
      ],
    );
  }
}

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key, required this.data});
  final User data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AccountTiles(
          icon: HugeIcons.strokeRoundedStudentCard,
          title: 'Username',
          subtitle: data.username,
          btnName: 'change',
          onTap: () {
            context.push(RouteNames.changeUsername, extra: data.username);
          },
        ),
        Divider(color: MyColors.grey, thickness: 2),
        AccountTiles(
          icon: HugeIcons.strokeRoundedMail01,
          title: 'Email address',
          subtitle: data.email,
          onTap: () {
            context.push(RouteNames.changeEmail, extra: data.email);
          },
          btnName: 'change',
        ),
        Divider(color: MyColors.grey, thickness: 2),
        AccountTiles(
          icon: HugeIcons.strokeRoundedSquareLock01,
          title: 'Password',
          onTap: () {
            context.push(RouteNames.updatePassword);
          },
          btnName: 'update',
        ),
      ],
    );
  }
}

class LoggedDevices extends StatelessWidget {
  const LoggedDevices({super.key, required this.sessions});

  final List<AllActiveSessionEntity> sessions;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sessions.length,
      separatorBuilder: (_, __) => Divider(color: MyColors.grey, thickness: 2),
      itemBuilder: (context, index) {
        final session = sessions[index];
        return AccountTiles(
          titleWidget: SpecialText(
            text: 'Session Id:${session.sessionId.substring(0, 8)}...',
            addText: session.isCurrent ? 'Current' : '',
            backColor: session.isCurrent
                ? MyColors.success.withAlpha((255 * .7).toInt())
                : MyColors.transparent,
            style: context.bodyLarge.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitleWidget: DeviceLocation(
            title:
                'CreatedAt:${formatDateTime(session.createdAt)}\nExpiresAt:${formatDateTime(session.expiresAt)}',
          ),

          onTap: session.isCurrent
              ? null
              : () {
                  showLogoutDialog(
                    context,
                    title: 'Log out of device?',
                    content:
                        'Are you sure you want to log out of this session?',
                    fTextBtn: 'Log Out',
                    sTextBtn: 'Cancel',
                    ontap: () {
                      context
                          .read<SettingsCubit>()
                          .revokeAllActiveSessionsExceptCurrent();
                      context.pop(context);
                    },
                  );
                },
          btnName: session.isCurrent ? '' : 'Log Out',
          textColor: MyColors.error,
          isCurrent: session.isCurrent,
        );
      },
    );
  }
}

String formatDateTime(DateTime date) {
  return DateFormat('dd MMM yyyy, hh:mm a').format(date);
}
