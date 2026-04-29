import 'reading_list_owner.dart';
import 'reading_list_paper.dart';

class ReadingList {
  final String id;
  final String title;
  final String? description;
  final bool isPublic;
  final String ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int paperCount;
  final bool isSaved;
  final List<String> previewTags;
  final List<ReadingListPaper>? papers;
  final ReadingListOwner? owner;

  const ReadingList({
    required this.id,
    required this.title,
    this.description,
    required this.isPublic,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    required this.paperCount,
    this.isSaved = false,
    required this.previewTags,
    this.papers,
    this.owner,
  });

  ReadingList copyWith({
    String? id,
    String? title,
    String? description,
    bool? isPublic,
    String? ownerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? paperCount,
    bool? isSaved,
    List<String>? previewTags,
    List<ReadingListPaper>? papers,
    ReadingListOwner? owner,
  }) {
    return ReadingList(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isPublic: isPublic ?? this.isPublic,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      paperCount: paperCount ?? this.paperCount,
      isSaved: isSaved ?? this.isSaved,
      previewTags: previewTags ?? this.previewTags,
      papers: papers ?? this.papers,
      owner: owner ?? this.owner,
    );
  }
}
