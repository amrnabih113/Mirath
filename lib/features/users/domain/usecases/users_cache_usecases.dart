import '../entities/user.dart';
import '../repositories/users_repository.dart';

class UsersCacheUseCases {
  final UsersRepository repository;

  UsersCacheUseCases({required this.repository});

  Future<User?> getCachedCurrentUser() {
    return repository.getCachedCurrentUser();
  }

  Future<void> cacheCurrentUser(User user) {
    return repository.cacheCurrentUser(user);
  }

  Future<User?> getCachedUserProfileHeader(String userId) {
    return repository.getCachedUserProfileHeader(userId);
  }

  Future<void> cacheUserProfileHeader(User user) {
    return repository.cacheUserProfileHeader(user);
  }

  Future<void> updateCachedFollowState({
    required String userId,
    required bool isFollowing,
  }) {
    return repository.updateCachedFollowState(
      userId: userId,
      isFollowing: isFollowing,
    );
  }
}
