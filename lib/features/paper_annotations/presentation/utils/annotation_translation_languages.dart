class AnnotationTranslationLanguage {
  final String code;
  final String name;

  const AnnotationTranslationLanguage({required this.code, required this.name});
}

class AnnotationTranslationLanguages {
  AnnotationTranslationLanguages._();

  static const List<AnnotationTranslationLanguage> supported = [
    AnnotationTranslationLanguage(code: 'ar', name: 'Arabic'),
    AnnotationTranslationLanguage(code: 'zh-cn', name: 'Chinese'),
    AnnotationTranslationLanguage(code: 'da', name: 'Danish'),
    AnnotationTranslationLanguage(code: 'nl', name: 'Dutch'),
    AnnotationTranslationLanguage(code: 'fil', name: 'Filipino'),
    AnnotationTranslationLanguage(code: 'fi', name: 'Finnish'),
    AnnotationTranslationLanguage(code: 'fr', name: 'French'),
    AnnotationTranslationLanguage(code: 'de', name: 'German'),
    AnnotationTranslationLanguage(code: 'el', name: 'Greek'),
    AnnotationTranslationLanguage(code: 'hi', name: 'Hindi'),
    AnnotationTranslationLanguage(code: 'is', name: 'Icelandic'),
    AnnotationTranslationLanguage(code: 'it', name: 'Italian'),
    AnnotationTranslationLanguage(code: 'ja', name: 'Japanese'),
    AnnotationTranslationLanguage(code: 'no', name: 'Norwegian'),
    AnnotationTranslationLanguage(code: 'pt', name: 'Portuguese'),
    AnnotationTranslationLanguage(code: 'ru', name: 'Russian'),
    AnnotationTranslationLanguage(code: 'es', name: 'Spanish'),
    AnnotationTranslationLanguage(code: 'sv', name: 'Swedish'),
    AnnotationTranslationLanguage(code: 'tr', name: 'Turkish'),
    AnnotationTranslationLanguage(code: 'uk', name: 'Ukrainian'),
  ];

  static AnnotationTranslationLanguage? byCode(String? code) {
    if (code == null || code.trim().isEmpty) return null;

    for (final language in supported) {
      if (language.code == code) return language;
    }

    return null;
  }
}
