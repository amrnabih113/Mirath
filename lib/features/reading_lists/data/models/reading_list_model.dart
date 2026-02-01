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
    required super.previewTags,
    super.papers,
    super.owner,
  });

  factory ReadingListModel.fromJson(Map<String, dynamic> json) {
    return ReadingListModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      isPublic: json['isPublic'] ?? true,
      ownerId: json['ownerId'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      paperCount: json['_count']?['papers'] ?? 0,
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
      '_count': {'papers': paperCount},
      'previewTags': previewTags,
      if (papers != null)
        'papers': papers!
            .map((p) => (p as ReadingListPaperModel).toJson())
            .toList(),
      if (owner != null) 'owner': (owner as ReadingListOwnerModel).toJson(),
    };
  }
}
