import 'package:mirath/core/utils/my_constants.dart';
import 'package:mirath/features/papers/data/models/full_paper_model.dart';

import '../../../../core/network/dio_client.dart';

abstract class PaperRemoteDataSource {
  Future<FullPaperModel> getPaperById(String id);
}

class PaperRemoteDataSourceImpl implements PaperRemoteDataSource {
  final DioClient dioClient;

  PaperRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<FullPaperModel> getPaperById(String id) async {
    final params = {'id': id};
    return await dioClient
        .get(
          MyConstants.getPaperById.replaceAll('{id}', id),
          queryParameters: params,
        )
        .then((response) {
          final data = response.data as Map<String, dynamic>;
          final papersJson = data['data'] as Map<String, dynamic>;
          return FullPaperModel.fromJson(papersJson);
        });
  }
}
