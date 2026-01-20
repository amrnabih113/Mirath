import 'package:equatable/equatable.dart';

class Interest extends Equatable {
  final String id;
  final String name;
  final bool custom;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Interest({
    required this.id,
    required this.name,
    required this.custom,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, custom, createdAt, updatedAt];

  Interest copyWith({
    String? id,
    String? name,
    bool? custom,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Interest(
      id: id ?? this.id,
      name: name ?? this.name,
      custom: custom ?? this.custom,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
