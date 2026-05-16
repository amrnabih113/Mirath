import '../error/failuors.dart';

enum ResourceStatus { loading, success, error }

class Resource<T> {
  final ResourceStatus status;
  final T? data;
  final Failure? failure;
  final bool fromCache;

  Resource._(this.status, {this.data, this.failure, this.fromCache = false});

  factory Resource.loading() => Resource._(ResourceStatus.loading);
  factory Resource.success(T data, {bool fromCache = false}) =>
      Resource._(ResourceStatus.success, data: data, fromCache: fromCache);
  factory Resource.error(Failure failure) =>
      Resource._(ResourceStatus.error, failure: failure);
}
