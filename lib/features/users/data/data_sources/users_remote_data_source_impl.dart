import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mirath/features/users/data/models/follows_model.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/my_constants.dart';
import '../../../../core/utils/my_logger.dart';
import '../../domain/entities/profile_setup_data.dart';
import '../../domain/entities/update_profile_data.dart';
import '../models/follow_response_model.dart';
import '../models/get_user_response_model.dart';
import '../models/profile_header_response_model.dart';
import '../models/profile_setup_response_model.dart';
import 'users_remote_data_source.dart';

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final DioClient dioClient;

  const UsersRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<ProfileSetupResponseModel> setupProfile(
    ProfileSetupData profileSetupData,
  ) async {
    try {
      MyLogger.info('[UsersRemoteDataSource] Setting up profile...');

      final formData = FormData.fromMap({
        'name': profileSetupData.name,
        'levelOfEducation': profileSetupData.levelOfEducation,
        // Only include university if it has valid content (2+ characters)
        if (profileSetupData.university != null &&
            profileSetupData.university!.length >= 2)
          'university': profileSetupData.university,
      });

      // Add interests as individual fields (proper multipart/form-data array)
      for (var interest in profileSetupData.interests) {
        formData.fields.add(MapEntry('interests', interest));
      }

      MyLogger.debug(
        '[UsersRemoteDataSource] Form fields: ${formData.fields.map((e) => '${e.key}=${e.value}').join(', ')}',
      );

      // Add profile photo if available
      if (profileSetupData.profilePhoto != null) {
        final file = profileSetupData.profilePhoto!;
        formData.files.add(
          MapEntry(
            'profilePhoto',
            await MultipartFile.fromFile(file.path, filename: file.name),
          ),
        );
        MyLogger.info(
          '[UsersRemoteDataSource] Profile photo added: ${file.name}',
        );
      }

      final response = await dioClient.post(
        MyConstants.setupProfile,
        data: formData,
      );

      MyLogger.info('[UsersRemoteDataSource] Profile setup successful');
      return ProfileSetupResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      MyLogger.error('[UsersRemoteDataSource] Profile setup failed: $e');
      if (e.response != null) {
        MyLogger.error(
          '[UsersRemoteDataSource] Response data: ${e.response?.data}',
        );
        MyLogger.error(
          '[UsersRemoteDataSource] Status code: ${e.response?.statusCode}',
        );
      }
      rethrow;
    } catch (e) {
      MyLogger.error('[UsersRemoteDataSource] Profile setup failed: $e');
      rethrow;
    }
  }

  @override
  Future<GetUserResponseModel> getCurrentUser() async {
    try {
      MyLogger.info('[UsersRemoteDataSource] Getting current user...');

      final response = await dioClient.get(MyConstants.getMe);

      MyLogger.info('[UsersRemoteDataSource] Get current user successful');
      return GetUserResponseModel.fromJson(response.data);
    } catch (e) {
      MyLogger.error('[UsersRemoteDataSource] Get current user failed: $e');
      rethrow;
    }
  }

  @override
  Future<ProfileHeaderResponseModel> getUserProfileHeader(String userId) async {
    try {
      MyLogger.info(
        '[UsersRemoteDataSource] Getting user profile header: $userId',
      );

      final endpoint = MyConstants.getUserProfileHeader.replaceAll(
        '{id}',
        userId,
      );
      final response = await dioClient.get(endpoint);

      MyLogger.info(
        '[UsersRemoteDataSource] Get user profile header successful',
      );
      return ProfileHeaderResponseModel.fromJson(response.data);
    } catch (e) {
      MyLogger.error(
        '[UsersRemoteDataSource] Get user profile header failed: $e',
      );
      rethrow;
    }
  }

  @override
  Future<FollowResponseModel> followUser(String userId) async {
    try {
      MyLogger.info('[UsersRemoteDataSource] Following user: $userId');

      final endpoint = MyConstants.followUser.replaceAll('{id}', userId);
      final response = await dioClient.post(endpoint);

      MyLogger.info('[UsersRemoteDataSource] Follow user successful');
      return FollowResponseModel.fromJson(response.data);
    } catch (e) {
      MyLogger.error('[UsersRemoteDataSource] Follow user failed: $e');
      rethrow;
    }
  }

  @override
  Future<FollowResponseModel> unfollowUser(String userId) async {
    try {
      MyLogger.info('[UsersRemoteDataSource] Unfollowing user: $userId');

      final endpoint = MyConstants.unfollowUser.replaceAll('{id}', userId);
      final response = await dioClient.delete(endpoint);

      MyLogger.info('[UsersRemoteDataSource] Unfollow user successful');

      final data = response.data;

      if (data is Map<String, dynamic>) {
        return FollowResponseModel.fromJson(data);
      }

      if (data == null || (data is String && data.trim().isEmpty)) {
        return const FollowResponseModel(message: '');
      }

      // Some APIs return a simple string/number or 204 No Content for delete
      // operations. Convert to a message-bearing model gracefully.
      return FollowResponseModel(message: data.toString());
    } catch (e) {
      MyLogger.error('[UsersRemoteDataSource] Unfollow user failed: $e');
      rethrow;
    }
  }

  @override
  Future<List<FollowsModel>> getUserFollowers(
    String id, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dioClient.get(
      MyConstants.getFollowers.replaceAll('{id}', id),
      queryParameters: {'page': page, 'limit': limit},
    );
    return FollowsModel.listFromResponse(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<FollowsModel>> getUserFollowing(
    String id, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dioClient.get(
      MyConstants.getFollowing.replaceAll('{id}', id),
      queryParameters: {'page': page, 'limit': limit},
    );
    return FollowsModel.listFromResponse(response.data as Map<String, dynamic>);
  }

  @override
  Future<ProfileSetupResponseModel> updateProfile(
    UpdateProfileData updateProfileData,
  ) async {
    try {
      MyLogger.info('[UsersRemoteDataSource] Updating profile...');

      final formData = FormData.fromMap({
        if (updateProfileData.fullName != null)
          'fullName': updateProfileData.fullName,
        if (updateProfileData.bio != null) 'bio': updateProfileData.bio,
        if (updateProfileData.country != null)
          'country': updateProfileData.country,
        if (updateProfileData.levelOfEducation != null)
          'levelOfEducation': updateProfileData.levelOfEducation,
        if (updateProfileData.university != null)
          'university': updateProfileData.university,
        if (updateProfileData.keepEmailPrivate != null)
          'keepEmailPrivate': updateProfileData.keepEmailPrivate,
      });

      if (updateProfileData.interests != null) {
        for (var interest in updateProfileData.interests as List<String>) {
          formData.fields.add(MapEntry('interests', interest));
        }
      }

      if (updateProfileData.profilePhoto != null) {
        final file = updateProfileData.profilePhoto as XFile;
        formData.files.add(
          MapEntry(
            'profilePhoto',
            await MultipartFile.fromFile(file.path, filename: file.name),
          ),
        );
      }

      final response = await dioClient.patch(
        MyConstants.updateProfile,
        data: formData,
      );

      MyLogger.info('[UsersRemoteDataSource] Profile update successful');
      return ProfileSetupResponseModel.fromJson(response.data);
    } catch (e) {
      MyLogger.error('[UsersRemoteDataSource] Update profile failed: $e');
      rethrow;
    }
  }
}
