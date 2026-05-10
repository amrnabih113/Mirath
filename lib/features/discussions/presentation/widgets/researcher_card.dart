import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/services/user_cache_service.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../injection/injection_container.dart';
import '../../../common/widgets/profile_avatar.dart';
import '../../../users/domain/entities/user.dart';
import '../../../users/domain/usecases/follow_user_usecase.dart';
import '../../../users/domain/usecases/unfollow_user_usecase.dart';

class ResearcherCard extends StatefulWidget {
  const ResearcherCard({super.key, required this.user, this.onTap});

  final User user;
  final VoidCallback? onTap;

  @override
  State<ResearcherCard> createState() => _ResearcherCardState();
}

class _ResearcherCardState extends State<ResearcherCard> {
  late bool _isFollowing;
  bool _isLoadingFollow = false;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.user.isFollowed == true;
  }

  void _openProfile(BuildContext context) {
    final currentUser = sl<UserCacheService>().getCachedUser();
    if (currentUser?.id == widget.user.id) {
      context.push(RouteNames.profile);
      return;
    }

    context.push(RouteNames.userProfileRoute(widget.user.id));
  }

  Future<void> _toggleFollow() async {
    if (_isLoadingFollow || widget.user.isMe) return;

    setState(() => _isLoadingFollow = true);

    final result = _isFollowing
        ? await sl<UnfollowUserUsecase>()(widget.user.id)
        : await sl<FollowUserUsecase>()(widget.user.id);

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _isLoadingFollow = false);
      },
      (_) {
        setState(() {
          _isFollowing = !_isFollowing;
          _isLoadingFollow = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap ?? () => _openProfile(context),
      borderRadius: BorderRadius.circular(
        ResponsiveHelper.responsiveValue(context, 18),
      ),
      child: Container(
        padding: MySizes.paddingSm(context),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.responsiveValue(context, 18),
          ),
          border: Border.all(
            color: MyColors.primaryShade300.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: MyColors.primaryShade500.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 6),
              spreadRadius: -3,
            ),
            BoxShadow(
              color: MyColors.primaryShade900.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
              spreadRadius: -1,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileAvatar(
              imageUrl: widget.user.photoUrl,
              size: ResponsiveHelper.responsiveValue(
                context,
                ResponsiveHelper.deviceTypeFromContext(context) !=
                        DeviceType.phone
                    ? 28
                    : 40,
              ),
            ),
            SizedBox(width: MySizes.spaceSm(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.user.fullName,
                    style: context.titleSmall.copyWith(
                      fontWeight: FontWeight.w900,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: MySizes.spaceXs(context) * 0.5),
                  Text(
                    widget.user.bio?.trim().isNotEmpty == true
                        ? widget.user.bio!
                        : '@${widget.user.username}',
                    style: context.bodySmall.copyWith(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: MySizes.spaceXs(context) * 0.5),
                  Text(
                    widget.user.country ?? widget.user.levelOfEducation,
                    style: context.bodySmall.copyWith(
                      color: MyColors.primaryShade700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (!widget.user.isMe) ...[
              SizedBox(width: MySizes.spaceSm(context)),
              InkWell(
                onTap: _toggleFollow,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.responsiveValue(context, 14),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MySizes.spaceSm(context),
                    vertical: MySizes.spaceXs(context),
                  ),
                  decoration: BoxDecoration(
                    color: _isFollowing
                        ? MyColors.primaryShade100
                        : MyColors.white,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.responsiveValue(context, 14),
                    ),
                    border: Border.all(
                      color: _isFollowing
                          ? MyColors.primaryShade300
                          : MyColors.primaryShade200,
                    ),
                  ),
                  child: _isLoadingFollow
                      ? SizedBox(
                          width: MySizes.iconSmall(context),
                          height: MySizes.iconSmall(context),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              MyColors.primaryShade700,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            HugeIcon(
                              icon: _isFollowing
                                  ? HugeIcons.strokeRoundedCheckmarkBadge01
                                  : HugeIcons.strokeRoundedAdd01,
                              size: MySizes.iconSmall(context) * 0.8,
                              color: MyColors.primaryShade700,
                            ),
                            SizedBox(width: MySizes.spaceXs(context) * 0.5),
                            Text(
                              _isFollowing ? 'Following' : 'Follow',
                              style: context.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: MyColors.primaryShade700,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}