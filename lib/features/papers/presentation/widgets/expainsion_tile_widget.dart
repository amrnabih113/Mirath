import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';

class ExpainsionTileWidget extends StatefulWidget {
  final List<String> references;
  final String title;
  final int? referencesCount;

  const ExpainsionTileWidget({
    super.key,
    this.references = const [],
    this.title = 'References',
    this.referencesCount,
  });

  @override
  State<ExpainsionTileWidget> createState() => _ExpainsionTileWidgetState();
}

class _ExpainsionTileWidgetState extends State<ExpainsionTileWidget> {
  final ExpansibleController _controller = ExpansibleController();
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    final referencesCount = widget.referencesCount ?? widget.references.length;

    return ExpansionTile(
      controller: _controller,
      shape: const Border(),
      collapsedShape: const Border(),
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.only(
        left: MySizes.spaceXs(context),
        right: MySizes.spaceXs(context),
        bottom: MySizes.spaceSm(context),
      ),
      trailing: const SizedBox.shrink(),
      leading: IconButton(
        onPressed: () {
          if (isOpen) {
            _controller.collapse();
          } else {
            _controller.expand();
          }
        },
        icon: AnimatedRotation(
          turns: isOpen ? 0.5 : 0,
          duration: const Duration(milliseconds: 200),
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowDown01,
            color: MyColors.primaryShade800,
          ),
        ),
      ),
      title: Text(
        '${widget.title} ($referencesCount)',
        style: context.headlineSmall.copyWith(
          color: MyColors.black,
          fontFamily: GoogleFonts.sourceSerif4().fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      onExpansionChanged: (value) {
        setState(() {
          isOpen = value;
        });
      },
      children: [
        if (widget.references.isEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: MySizes.spaceSm(context)),
            child: Text(
              'No references available.',
              style: context.bodyMedium.copyWith(
                color: MyColors.primaryShade700,
                fontFamily: GoogleFonts.sourceSerif4().fontFamily,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.references.length,
            separatorBuilder: (_, _) =>
                SizedBox(height: MySizes.spaceXs(context)),
            itemBuilder: (context, index) {
              final reference = widget.references[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '[${index + 1}]',
                    style: context.bodyMedium.copyWith(
                      color: MyColors.primaryShade700,
                      fontFamily: GoogleFonts.sourceSerif4().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: MySizes.spaceXs(context)),
                  Expanded(
                    child: Text(
                      reference,
                      style: context.bodyMedium.copyWith(
                        color: MyColors.black,
                        fontFamily: GoogleFonts.sourceSerif4().fontFamily,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
