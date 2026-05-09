import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/injection/injection_container.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/services/user_cache_service.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../core/constants/route_names.dart';
import '../../../common/widgets/profile_avatar.dart';
import '../../domain/entities/discussion.dart';
import '../cubit/community_cubit.dart';
import 'follow_button.dart';

class UserInformationHeader extends StatefulWidget {
  final Discussion discussion;
  final bool showMoreButton;

  const UserInformationHeader({
    super.key,
    required this.discussion,
    this.showMoreButton = true,
  });

  @override
  State<UserInformationHeader> createState() => _UserInformationHeaderState();
}

class _UserInformationHeaderState extends State<UserInformationHeader> {
  late bool _isFollowing;
  bool _isLoadingFollow = false;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.discussion.author.isFollowing;
  }

  void _openAuthorProfile(BuildContext context) {
    final currentUser = sl<UserCacheService>().getCachedUser();
    if (currentUser?.id == widget.discussion.author.id) {
      context.push(RouteNames.profile);
      return;
    }

    context.push(RouteNames.userProfileRoute(widget.discussion.author.id));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _openAuthorProfile(context),
            child: Row(
              children: [
                ProfileAvatar(
                  imageUrl: widget.discussion.author.photoUrl,
                  size: ResponsiveHelper.responsiveValue(
                    context,
                    ResponsiveHelper.deviceTypeFromContext(context) !=
                            DeviceType.phone
                        ? 25
                        : 40,
                  ),
                ),
                SizedBox(width: MySizes.spaceSm(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.discussion.author.fullName,
                        style: context.titleSmall.copyWith(
                          fontWeight: FontWeight.w900,
                          overflow: TextOverflow.ellipsis,
                          fontSize: ResponsiveHelper.responsiveValue(
                            context,
                            14,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: MySizes.spaceXs(context) * 0.5),
                      Text(
                        widget.discussion.author.bio ??
                            '@${widget.discussion.author.username}',
                        style: context.bodySmall.copyWith(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!widget.discussion.author.isMe) ...[
          SizedBox(width: MySizes.spaceXs(context)),
          Padding(
            padding: EdgeInsets.only(top: MySizes.spaceXs(context) * 0.25),
            child: FollowButton(
              userId: widget.discussion.author.id,
              isFollowed: _isFollowing,
              isLoading: _isLoadingFollow,
              onFollowTap: () async {
                setState(() => _isLoadingFollow = true);
                await context.read<CommunityCubit>().followUser(
                  widget.discussion.author.id,
                );
                if (mounted) {
                  setState(() {
                    _isFollowing = true;
                    _isLoadingFollow = false;
                  });
                }
              },
              onUnfollowTap: () async {
                setState(() => _isLoadingFollow = true);
                await context.read<CommunityCubit>().unfollowUser(
                  widget.discussion.author.id,
                );
                if (mounted) {
                  setState(() {
                    _isFollowing = false;
                    _isLoadingFollow = false;
                  });
                }
              },
            ),
          ),
        ],
        if (widget.showMoreButton)
          Padding(
            padding: EdgeInsets.only(left: MySizes.spaceXs(context)),
            child: IconButton(
              onPressed: () {},
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedMoreHorizontal,
                size: MySizes.iconMedium(context),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
      ],
    );
  }
}
