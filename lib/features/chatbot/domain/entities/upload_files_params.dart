import 'dart:io';

import 'package:dio/dio.dart';

import '../../data/models/chatbot_message_attachment.dart';

typedef ProgressCb = void Function(int sent, int total);

class UploadFilesParams {
  final List<File> files;
  final AttachmentType type;
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
