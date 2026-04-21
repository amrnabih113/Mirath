import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/paper_annotations/presentation/utils/annotation_translation_languages.dart';
import 'package:share_plus/share_plus.dart';
import 'package:translator/translator.dart';

class TranslationSheet extends StatefulWidget {
  final String text;
  final String? initialTargetLanguageCode;
  final Future<void> Function(String languageCode)? onTargetLanguageChanged;

  const TranslationSheet({
    super.key,
    required this.text,
    this.initialTargetLanguageCode,
    this.onTargetLanguageChanged,
  });

  @override
  State<TranslationSheet> createState() => _TranslationSheetState();
}

class _TranslationSheetState extends State<TranslationSheet> {
  final GoogleTranslator _translator = GoogleTranslator();

  bool _isLoading = false;
  String? _translatedText;
  String? _errorMessage;
  String? _targetLanguageCode;

  bool get _isFirstTimeLanguageSelection => _targetLanguageCode == null;

  AnnotationTranslationLanguage? get _targetLanguage {
    return AnnotationTranslationLanguages.byCode(_targetLanguageCode);
  }

  @override
  void initState() {
    super.initState();
    _targetLanguageCode = widget.initialTargetLanguageCode;

    if (_targetLanguageCode != null) {
      _translate();
    }
  }

  Future<void> _translate() async {
    final targetCode = _targetLanguageCode;
    if (targetCode == null || widget.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _translator.translate(
        widget.text,
        from: 'auto',
        to: targetCode,
      );

      if (!mounted) return;
      setState(() {
        _translatedText = response.text;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _translatedText = null;
        _isLoading = false;
        _errorMessage = 'Failed to translate. Please try again.';
      });
    }
  }

  Future<void> _onLanguageSelected(String languageCode) async {
    setState(() {
      _targetLanguageCode = languageCode;
      _translatedText = null;
      _errorMessage = null;
    });

    if (widget.onTargetLanguageChanged != null) {
      await widget.onTargetLanguageChanged!(languageCode);
    }

    await _translate();
  }

  Future<void> _openLanguageSelector() async {
    if (!mounted) return;

    final selected = await showDialog<String>(
      
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.08),
      builder: (dialogContext) {
        final maxDialogHeight = MediaQuery.of(dialogContext).size.height * 0.5;

        return Dialog(
          elevation: 12,
        
          insetPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.responsiveValue(dialogContext, 24),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: maxDialogHeight,
              maxWidth: ResponsiveHelper.responsiveValue(dialogContext, 100),
            ),
            decoration: BoxDecoration(
              color: MyColors.light,
              borderRadius: BorderRadius.circular(
                MySizes.borderRadiusLg(dialogContext) * 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.14),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                vertical: MySizes.spaceSm(dialogContext),
              ),
              physics: const BouncingScrollPhysics(),
              itemCount: AnnotationTranslationLanguages.supported.length,
              separatorBuilder: (_, _) => SizedBox(
                height: ResponsiveHelper.responsiveValue(dialogContext, 2),
              ),
              itemBuilder: (itemContext, index) {
                final language =
                    AnnotationTranslationLanguages.supported[index];
                final isSelected = language.code == _targetLanguageCode;

                return InkWell(
                  onTap: () => Navigator.of(dialogContext).pop(language.code),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MySizes.spaceMd(itemContext),
                      vertical: MySizes.spaceSm(itemContext),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: ResponsiveHelper.responsiveValue(
                            itemContext,
                            28,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, size: 24)
                              : null,
                        ),
                        SizedBox(width: MySizes.spaceSm(itemContext)),
                        Text(language.name, style: itemContext.bodyLarge),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    if (selected == null || selected == _targetLanguageCode) return;
    await _onLanguageSelected(selected);
  }

  String _detectSourceLanguageLabel(String text) {
    final value = text.trim();
    if (value.isEmpty) return 'Unknown';

    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    final cjkRegex = RegExp(r'[\u4E00-\u9FFF]');

    if (arabicRegex.hasMatch(value)) return 'Arabic';
    if (cjkRegex.hasMatch(value)) return 'Chinese';

    return 'English';
  }

  Widget _buildPrimaryContent(BuildContext context) {
    final sourceLanguage = _detectSourceLanguageLabel(widget.text);

    if (_isFirstTimeLanguageSelection) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose a language',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: MySizes.spaceSm(context)),
          ...AnnotationTranslationLanguages.supported.map((language) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () => _onLanguageSelected(language.code),
              title: Text(
                language.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                style: context.titleMedium,
                children: [
                  const TextSpan(text: 'Detected as '),
                  TextSpan(
                    text: sourceLanguage,
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: MySizes.spaceXs(context)),
            HugeIcon(
              icon: HugeIcons.strokeRoundedUnfoldMore,
              size: MySizes.iconSmall(context),
            ),
          ],
        ),
        SizedBox(height: MySizes.spaceSm(context)),
        Text(widget.text, style: context.bodyLarge),
        SizedBox(height: MySizes.spaceSm(context)),
        const Divider(thickness: 1),
        SizedBox(height: MySizes.spaceSm(context)),
        InkWell(
          onTap: _openLanguageSelector,
          borderRadius: BorderRadius.circular(MySizes.borderRadiusSm(context)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: MySizes.spaceXs(context)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _targetLanguage?.name ?? 'Choose language',
                  style: context.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: MySizes.spaceXs(context)),
                HugeIcon(
                  icon: HugeIcons.strokeRoundedUnfoldMore,
                  size: MySizes.iconSmall(context),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: MySizes.spaceSm(context)),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                _errorMessage!,
                style: context.bodyLarge.copyWith(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          Text(
            _translatedText ?? '',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
        if ((_translatedText ?? '').isNotEmpty) ...[
          SizedBox(height: MySizes.spaceSm(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _translatedText!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard')),
                  );
                },
                icon: HugeIcon(icon: HugeIcons.strokeRoundedCopy01),
              ),
              IconButton(
                onPressed: () {
                  SharePlus.instance.share(ShareParams(text: _translatedText!));
                },
                icon: HugeIcon(icon: HugeIcons.strokeRoundedShare08),
              ),
            ],
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.light,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(MySizes.borderRadiusLg(context)),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: MySizes.paddingMd(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MySizes.spaceSm(context)),
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedMultiplicationSign,
                        size: MySizes.iconMedium(context),
                      ),
                    ),
                    const Spacer(),
                    Text('Translate', style: context.headlineSmall),
                    const Spacer(),
                    SizedBox(
                      width: ResponsiveHelper.responsiveValue(context, 42),
                    ),
                  ],
                ),
                SizedBox(height: MySizes.spaceXl(context)),
                Container(
                  width: double.infinity,
                  padding: MySizes.paddingMd(context),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9E5),
                    borderRadius: BorderRadius.circular(
                      MySizes.borderRadiusLg(context),
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: KeyedSubtree(
                      key: ValueKey<String>(
                        _isFirstTimeLanguageSelection
                            ? 'language-picker'
                            : 'translation-content',
                      ),
                      child: _buildPrimaryContent(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
