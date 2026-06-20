class FileUploadResponse {
  final String id;

  FileUploadResponse({required this.id});

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) {
    // API returns { data: { id: '...' } } or { id: '...'}
    final data = json['data'] ?? json;
    return FileUploadResponse(id: data['id']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() => {'id': id};
}
