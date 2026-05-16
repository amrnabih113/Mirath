import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../users/domain/entities/follows.dart';

class FollowerFollowingCard extends StatefulWidget {
  const FollowerFollowingCard({
    super.key,
    required this.user,
    required this.onUserTap,
    required this.onFollowToggle,
  });

  final Follows user;
  final VoidCallback onUserTap;
  final Function(bool) onFollowToggle;

  @override
  State<FollowerFollowingCard> createState() => _FollowerFollowingCardState();
}

class _FollowerFollowingCardState extends State<FollowerFollowingCard> {
  late bool _isFollowing;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.user.isFollowing;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(
      ResponsiveHelper.responsiveValue(context, 18),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onUserTap,
        borderRadius: borderRadius,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.responsiveValue(context, 12),
            vertical: ResponsiveHelper.responsiveValue(context, 12),
          ),
          decoration: BoxDecoration(
            color: MyColors.white,
            borderRadius: borderRadius,
            border: Border.all(color: MyColors.primaryShade800, width: 1),
            boxShadow: [
              BoxShadow(
                color: MyColors.primaryShade900.withValues(alpha: 0.08),
                blurRadius: ResponsiveHelper.responsiveValue(context, 18),
                offset: Offset(0, ResponsiveHelper.responsiveValue(context, 6)),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: MyColors.primaryShade800.withValues(alpha: 0.25),
                  ),
                ),
                child: CircleAvatar(
                  radius: MySizes.borderRadiusLg(context),
                  backgroundColor: MyColors.primaryShade50,
                  backgroundImage: widget.user.photoUrl.isNotEmpty
                      ? NetworkImage(widget.user.photoUrl)
                      : null,
                  child: widget.user.photoUrl.isEmpty
                      ? SvgPicture.asset(
                          'assets/images/Profile picture (1).svg',
                        )
                      : null,
                ),
              ),
              SizedBox(width: MySizes.spaceSm(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.user.fullname,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.titleSmall.copyWith(
                              color: MyColors.primaryShade900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: MyColors.primaryShade50,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            widget.user.role,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.bodySmall.copyWith(
                              color: MyColors.primaryShade900,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MySizes.spaceXs(context) * 0.4),
                    Text(
                      widget.user.bio.isNotEmpty
                          ? widget.user.bio
                          : '@${widget.user.username}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.bodySmall.copyWith(
                        color: MyColors.primaryShade700,
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                  
                  ],
                ),
              ),
              SizedBox(width: MySizes.spaceSm(context)),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _isLoading
                    ? SizedBox(
                        key: const ValueKey('loading'),
                        width: MySizes.iconSmall(context) * 1.2,
                        height: MySizes.iconSmall(context) * 1.2,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            MyColors.primaryShade900,
                          ),
                        ),
                      )
                    : Material(
                        key: ValueKey(_isFollowing),
                        color: _isFollowing
                            ? MyColors.primaryShade900
                            : MyColors.primaryShade50,
                        borderRadius: BorderRadius.circular(999),
                        child: InkWell(
                          onTap: () async {
                            if (_isLoading) return;
                            setState(() => _isLoading = true);
                            await widget.onFollowToggle(_isFollowing);
                            if (mounted) {
                              setState(() {
                                _isFollowing = !_isFollowing;
                                _isLoading = false;
                              });
                            }
                          },
                          borderRadius: BorderRadius.circular(999),
                          child: Padding(
                            padding: EdgeInsets.all(
                              ResponsiveHelper.responsiveValue(context, 10),
                            ),
                            child: HugeIcon(
                              icon: _isFollowing
                                  ? HugeIcons.strokeRoundedUserCheck01
                                  : HugeIcons.strokeRoundedUserAdd01,
                              size: MySizes.iconSmall(context),
                              color: _isFollowing
                                  ? Colors.white
                                  : MyColors.primaryShade900,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
