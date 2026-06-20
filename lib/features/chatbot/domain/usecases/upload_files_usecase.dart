import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/upload_files_params.dart';
import '../../data/models/file_upload_response.dart';
import '../repositories/chatbot_repository.dart';

class UploadFilesUseCase
    implements UseCase<List<FileUploadResponse>, UploadFilesParams> {
  final ChatbotRepository repository;

  UploadFilesUseCase(this.repository);

  @override
  Future<Either<Failure, List<FileUploadResponse>>> call(
    UploadFilesParams params,
  ) async {
    return await repository.uploadFiles(
      params.files,
      params.type,
      durationSeconds: params.durationSeconds,
      onProgress: params.onProgress,
    );
  }
}
