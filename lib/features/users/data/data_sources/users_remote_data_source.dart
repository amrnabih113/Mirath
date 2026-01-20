import '../models/follow_response_model.dart';
import '../models/get_user_response_model.dart';
import '../models/profile_setup_response_model.dart';
import '../../domain/entities/profile_setup_data.dart';

abstract class UsersRemoteDataSource {
  Future<ProfileSetupResponseModel> setupProfile(
    ProfileSetupData profileSetupData,
  );
  Future<GetUserResponseModel> getCurrentUser();
  Future<FollowResponseModel> followUser(String userId);
  Future<FollowResponseModel> unfollowUser(String userId);
}
