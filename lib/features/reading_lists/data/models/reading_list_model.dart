import '../../domain/entities/reading_list.dart';
import 'reading_list_owner_model.dart';
import 'reading_list_paper_model.dart';

class ReadingListModel extends ReadingList {
  const ReadingListModel({
    required super.id,
    required super.title,
    super.description,
    required super.isPublic,
    required super.ownerId,
    required super.createdAt,
    required super.updatedAt,
    required super.paperCount,
    super.isSaved,
    required super.previewTags,
    super.papers,
    super.owner,
  });

  factory ReadingListModel.fromJson(Map<String, dynamic> json) {
    // Handle both regular reading lists and saved reading lists responses
    final id = json['id'] ?? json['readingListId'] ?? '';
    final ownerId = json['ownerId'] ?? json['userId'] ?? '';
    final timestamp =
        json['createdAt'] ??
        json['updatedAt'] ??
        json['savedAt'] ??
        DateTime.now().toIso8601String();

    return ReadingListModel(
      id: id,
      title: json['title'] ?? 'Reading List',
      description: json['description'],
      isPublic: json['isPublic'] ?? true,
      ownerId: ownerId,
      createdAt: timestamp is DateTime
          ? timestamp
          : (timestamp is String ? DateTime.parse(timestamp) : DateTime.now()),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is DateTime
                ? json['updatedAt']
                : DateTime.parse(json['updatedAt']))
          : (timestamp is DateTime
                ? timestamp
                : DateTime.parse(timestamp as String)),
      paperCount: json['paperCount'] ?? json['_count']?['papers'] ?? 0,
      isSaved: json['isSaved'] ?? true,
      previewTags:
          (json['previewTags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      papers: json['papers'] != null
          ? (json['papers'] as List<dynamic>)
                .map(
                  (e) =>
                      ReadingListPaperModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : null,
      owner: json['owner'] != null
          ? ReadingListOwnerModel.fromJson(
              json['owner'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isPublic': isPublic,
      'ownerId': ownerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'paperCount': paperCount,
      'isSaved': isSaved,
      'previewTags': previewTags,
      if (papers != null)
        'papers': papers!
            .map((p) => (p as ReadingListPaperModel).toJson())
            .toList(),
      if (owner != null) 'owner': (owner as ReadingListOwnerModel).toJson(),
    };
  }
}
