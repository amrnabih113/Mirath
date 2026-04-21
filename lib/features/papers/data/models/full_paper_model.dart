import 'package:mirath/features/papers/domain/entites/full_paper_entity.dart';

class FullPaperModel extends FullPaperEntity {
  const FullPaperModel({
    required super.id,
    required super.citation,
    required super.title,
    required super.abstract,
    required super.authors,
    required super.categories,
    required super.publishedAt,
    required super.content,
    required super.createdAt,
    required super.updatedAt,
  });

  factory FullPaperModel.fromJson(Map<String, dynamic> json) {
    // Parse content or use mock data for testing if backend doesn't provide it
    List<String> content = json['content'] != null
        ? List<String>.from(json['content'] as List)
        : _generateMockContent(json['abstract'] ?? '', json['title'] ?? '');

    // Clean the HTML content to remove LaTeX commands and unwanted sections
    content = _cleanHtmlContent(content);

    return FullPaperModel(
      id: json['id'],
      citation: json['citation'],
      title: json['title'],
      abstract: json['abstract'],
      authors: List<String>.from(json['authors'] ?? []),
      categories: List<String>.from(json['categories'] ?? []),
      publishedAt: DateTime.parse(json['publishedAt']),
      content: content,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  /// Remove everything before the abstract section from HTML content
  static List<String> _cleanHtmlContent(List<String> content) {
    if (content.isEmpty) return content;

    final cleanedContent = <String>[];
    bool foundAbstract = false;

    for (final chunk in content) {
      // Look for abstract section markers (case-insensitive)
      final lowerChunk = chunk.toLowerCase();

      if (!foundAbstract) {
        // Check if this chunk contains the abstract heading
        if (lowerChunk.contains('<h1') && lowerChunk.contains('abstract') ||
            lowerChunk.contains('<h2') && lowerChunk.contains('abstract') ||
            lowerChunk.contains('class="abstract"') ||
            lowerChunk.contains('class="ltx_abstract"') ||
            lowerChunk.contains('id="abstract"')) {
          foundAbstract = true;
          cleanedContent.add(chunk);
        }
      } else {
        // After finding abstract, include all remaining content
        cleanedContent.add(chunk);
      }
    }

    // If we never found an abstract section, return original content
    return cleanedContent.isNotEmpty ? cleanedContent : content;
  }

  /// Generate mock HTML content for testing when backend doesn't provide it
  /// TODO: Remove this once backend starts returning actual paper content
  static List<String> _generateMockContent(String abstract, String title) {
    return [
      '<h1>$title</h1>',
      '<h2>Abstract</h2>',
      '<p>$abstract</p>',
      '<h2>1. Introduction</h2>',
      '<p>This is a mock paper content for testing purposes. The backend does not yet provide the full paper HTML content, so this temporary content is being displayed.</p>',
      '<p>Once the backend implements the content field in the GET /api/v1/papers/{id} endpoint, this mock data will be replaced with actual paper content.</p>',
      '<h2>2. Methodology</h2>',
      '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>',
      '<h3>2.1 Data Collection</h3>',
      '<p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>',
      '<h3>2.2 Analysis</h3>',
      '<p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.</p>',
      '<h2>3. Results</h2>',
      '<p>Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.</p>',
      '<p>Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.</p>',
      '<h2>4. Discussion</h2>',
      '<p>At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident.</p>',
      '<h2>5. Conclusion</h2>',
      '<p>Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus.</p>',
      '<h2>References</h2>',
      '<ol>',
      '<li>Author A. et al. (2024). "Sample Paper Title". Journal Name, 10(2), 123-145.</li>',
      '<li>Author B. et al. (2023). "Another Sample Paper". Conference Proceedings, 456-478.</li>',
      '</ol>',
    ];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'citation': citation,
      'title': title,
      'abstract': abstract,
      'authors': authors,
      'categories': categories,
      'publishedAt': publishedAt.toIso8601String(),
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  FullPaperEntity toEntity() {
    return FullPaperEntity(
      id: id,
      citation: citation,
      title: title,
      abstract: abstract,
      authors: authors,
      categories: categories,
      publishedAt: publishedAt,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
