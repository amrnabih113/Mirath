import 'dart:io';

import 'package:dio/dio.dart';

typedef ProgressCb = void Function(int sent, int total);

class UploadFilesParams {
  final List<File> files;
  final String type;
  final int? durationSeconds;
  final ProgressCb? onProgress;
  final CancelToken? cancelToken;

  UploadFilesParams({
    required this.files,
    required this.type,
    this.durationSeconds,
    this.onProgress,
    this.cancelToken,
  });
}
