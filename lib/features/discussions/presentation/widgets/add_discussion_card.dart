import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/user_cache_service.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_constants.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../injection/injection_container.dart';
import '../../../common/widgets/profile_avatar.dart';
import '../../../users/domain/entities/user.dart';

class AddDiscussionCard extends StatelessWidget {
  const AddDiscussionCard({super.key});

  User? _getStoredUser() {
    final userJson = sl<LocalStorageService>().getData(MyConstants.userDataKey);
    if (userJson == null || userJson.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(userJson);
      if (decoded is Map<String, dynamic>) {
        return User.fromJson(decoded);
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cachedUser = sl<UserCacheService>().getCachedUser();
    final storedUser = _getStoredUser();

    return InkWell(
      onTap: () {
        context.push(RouteNames.addDiscussion);
      },
      borderRadius: BorderRadius.circular(MySizes.borderRadiusLg(context)),
      child: Container(
        padding: EdgeInsets.all(MySizes.spaceMd(context)),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(MySizes.borderRadiusLg(context)),
          border: Border.all(color: MyColors.primaryShade200, width: 1.5),
        ),
        child: Row(
          children: [
            ProfileAvatar(
              imageUrl: cachedUser?.photoURL ?? storedUser?.photoUrl,
              size: 45,
            ),
            SizedBox(width: MySizes.spaceSm(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    cursorColor: MyColors.primaryColor,
                    enabled: false,
                    style: TextStyle(
                      fontSize: 12,
                      color: MyColors.primaryShade700,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: MyColors.primaryShade50,
                      hint: Text(
                        'What would you like to discuss?',
                        style: TextStyle(
                          fontSize: 15,
                          color: MyColors.primaryShade800,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(MySizes.spaceXs(context)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          MySizes.borderRadiusSm(context),
                        ),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
