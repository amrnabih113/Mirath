import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioRecorderService {
  final Record _rec = Record();
  DateTime? _startTime;

  Future<bool> hasPermission() async {
    return await _rec.hasPermission();
  }

  Future<void> startRecording(String filename) async {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/$filename';
    _startTime = DateTime.now();
    await _rec.start(path: path, encoder: AudioEncoder.wav);
  }

  Future<Map<String, dynamic>?> stopRecording() async {
    final path = await _rec.stop();
    if (path == null) return null;
    final end = DateTime.now();
    final duration = _startTime == null
        ? 0
        : end.difference(_startTime!).inSeconds;
    return {'file': File(path), 'duration': duration};
  }

  Future<void> cancelRecording() async {
    await _rec.stop();
  }
}
