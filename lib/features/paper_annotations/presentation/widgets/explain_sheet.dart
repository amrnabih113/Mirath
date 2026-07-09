import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';
import '../cubit/paper_reading_cubit.dart';
import '../cubit/paper_reading_state.dart';

class ExplainSheet extends StatefulWidget {
  const ExplainSheet({super.key, required this.selectedText});

  final String selectedText;

  @override
  State<ExplainSheet> createState() => _ExplainSheetState();
}

class _ExplainSheetState extends State<ExplainSheet> {
  bool _isBookmarked = false;
  bool _liked = false;
  bool _disliked = false;

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(S.of(context).copied_to_clipboard)));
  }

  void _share(String text) {
    SharePlus.instance.share(ShareParams(text: text));
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  void _toggleLike() {
    setState(() {
      _liked = !_liked;

      if (_liked) {
        _disliked = false;
      }
    });
  }

  void _toggleDislike() {
    setState(() {
      _disliked = !_disliked;

      if (_disliked) {
        _liked = false;
      }
    });
  }

  Widget _buildActionButtons(String explanation) {
    return Row(
      children: [
        IconButton(
          onPressed: _toggleBookmark,
          icon: HugeIcon(
            icon: _isBookmarked
                ? HugeIcons.strokeRoundedBookmark02
                : HugeIcons.strokeRoundedBookmark01,
          ),
        ),
        IconButton(
          onPressed: () => _copy(explanation),
          icon: HugeIcon(icon: HugeIcons.strokeRoundedCopy01),
        ),
        IconButton(
          onPressed: _toggleLike,
          icon: HugeIcon(icon: HugeIcons.strokeRoundedThumbsUp),
        ),
        IconButton(
          onPressed: _toggleDislike,
          icon: HugeIcon(icon: HugeIcons.strokeRoundedThumbsDown),
        ),
        IconButton(
          onPressed: () => _share(explanation),
          icon: HugeIcon(icon: HugeIcons.strokeRoundedShare08),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildResult(String explanation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MarkdownBody(data: explanation),
        SizedBox(height: MySizes.spaceMd(context)),
        _buildActionButtons(explanation),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaperReadingCubit, PaperReadingState>(
      builder: (context, state) {
        if (state is! PaperReadingLoaded) {
          return const SizedBox.shrink();
        }

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: MySizes.spaceSm(context)),

                    /// Header
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedMultiplicationSign,
                            size: MySizes.iconMedium(context),
                          ),
                        ),

                        const Spacer(),

                        Text("Explain", style: context.headlineSmall),

                        const Spacer(),

                        SizedBox(
                          width: ResponsiveHelper.responsiveValue(context, 42),
                        ),
                      ],
                    ),

                    SizedBox(height: MySizes.spaceXl(context)),

                    /// Main Card
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Selected Text
                        Text(
                          widget.selectedText,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: context.bodyLarge.copyWith(
                            height: 1.6,
                            fontWeight: FontWeight.w600,
                            backgroundColor: MyColors.primaryShade100,
                          ),
                        ),
                        SizedBox(height: MySizes.spaceLg(context)),

                        Divider(color: Colors.grey.shade400),

                        SizedBox(height: MySizes.spaceLg(context)),

                        /// Explanation Result
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: state.explanationLoading
                              ? _buildLoading()
                              : _buildResult(
                                  state.explainedText ??
                                      "No explanation available.",
                                ),
                        ),
                      ],
                    ),

                    SizedBox(height: MediaQuery.of(context).padding.bottom),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
