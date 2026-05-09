import 'package:mirath/features/users/data/models/follows_model.dart';

import '../../domain/entities/profile_setup_data.dart';
import '../../domain/entities/update_profile_data.dart';
import '../models/follow_response_model.dart';
import '../models/get_user_response_model.dart';
import '../models/profile_header_response_model.dart';
import '../models/profile_setup_response_model.dart';

abstract class UsersRemoteDataSource {
  Future<ProfileSetupResponseModel> setupProfile(
    ProfileSetupData profileSetupData,
  );
  Future<ProfileSetupResponseModel> updateProfile(
    UpdateProfileData updateProfileData,
  );
  Future<GetUserResponseModel> getCurrentUser();
  Future<ProfileHeaderResponseModel> getUserProfileHeader(String userId);
  Future<FollowResponseModel> followUser(String userId);
  Future<FollowResponseModel> unfollowUser(String userId);
  Future<List<FollowsModel>> getUserFollowers(String id, {int page, int limit});
  Future<List<FollowsModel>> getUserFollowing(String id, {int page, int limit});
}
