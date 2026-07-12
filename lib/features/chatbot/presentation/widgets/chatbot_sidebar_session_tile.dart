import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_sizes.dart';

import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../domain/entities/session.dart';

class ChatbotSidebarSessionTile extends StatefulWidget {
  final Session session;
  final bool isActive;
  final String timestamp;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onMore;

  const ChatbotSidebarSessionTile({
    super.key,
    required this.session,
    required this.isActive,
    required this.timestamp,
    required this.onTap,
    required this.onDelete,
    required this.onMore,
  });

  @override
  State<ChatbotSidebarSessionTile> createState() =>
      _ChatbotSidebarSessionTileState();
}

class _ChatbotSidebarSessionTileState extends State<ChatbotSidebarSessionTile> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: Container(
        decoration: BoxDecoration(
          color: widget.isActive
              ? MyColors.primaryButton.withValues(alpha: 0.12)
              : MyColors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.responsiveValue(context, 12),
          ),
          border: widget.isActive
              ? Border.all(color: MyColors.primaryButton)
              : Border.all(color: MyColors.transparent),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.responsiveValue(context, 12),
          ),
          onTap: widget.onTap,
          child: Padding(
            padding: MySizes.paddingSm(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: ResponsiveHelper.responsiveValue(context, 38),
                  height: ResponsiveHelper.responsiveValue(context, 38),
                  decoration: BoxDecoration(
                    color: MyColors.primaryShade400.withValues(alpha: 0.24),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(
                    ResponsiveHelper.responsiveValue(context, 8),
                  ),
                  child: HugeIcon(
                    icon: widget.session.isTemporary
                        ? HugeIconsStrokeRounded.clock01
                        : HugeIconsStrokeRounded.strokeRoundedBubbleChat,
                    color: MyColors.primaryShade600,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.responsiveValue(context, 10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 210),
                            child: Text(
                              widget.session.title ?? 'Untitled chat',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.bodyMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: MyColors.textPrimary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: widget.onMore,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints.tightFor(
                              width: ResponsiveHelper.responsiveValue(
                                context,
                                28,
                              ),
                              height: ResponsiveHelper.responsiveValue(
                                context,
                                28,
                              ),
                            ),
                            icon: const HugeIcon(
                              icon: HugeIconsStrokeRounded.moreHorizontal,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          HugeIcon(
                            icon: HugeIconsStrokeRounded.clock01,
                            size: ResponsiveHelper.responsiveValue(context, 10),
                            color: MyColors.textSecondary,
                          ),
                          SizedBox(
                            width: ResponsiveHelper.responsiveValue(context, 4),
                          ),
                          Text(
                            widget.timestamp,
                            style: context.bodySmall.copyWith(
                              color: MyColors.textSecondary,
                              fontSize: ResponsiveHelper.responsiveValue(
                                context,
                                10,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: ResponsiveHelper.responsiveValue(context, 8),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
