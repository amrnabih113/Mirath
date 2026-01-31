// Example response for POST /api/v1/papers/{id}/save
// ```json
// {
//   "message": "Paper saved successfully",
//   "data": {
//     "id": "paper-id-123",
//     "userId": "user-id-456",
//     "paperId": "paper-id-123",
//     "createdAt": "2025-12-10T10:30:00.000Z"
//   }
// }
// ```

class SavePaperResponseModel {
  final String message;
  final SavedPaperData data;

  const SavePaperResponseModel({required this.message, required this.data});

  factory SavePaperResponseModel.fromJson(Map<String, dynamic> json) {
    return SavePaperResponseModel(
      message: json['message'] ?? '',
      data: SavedPaperData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'data': data.toJson()};
  }
}

class SavedPaperData {
  final String id;
  final String userId;
  final String paperId;
  final String createdAt;

  const SavedPaperData({
    required this.id,
    required this.userId,
    required this.paperId,
    required this.createdAt,
  });

  factory SavedPaperData.fromJson(Map<String, dynamic> json) {
    return SavedPaperData(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      paperId: json['paperId'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'paperId': paperId,
      'createdAt': createdAt,
    };
  }
}
