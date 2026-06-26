import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class ColorPalette extends StatefulWidget {
  const ColorPalette({super.key});

  @override
  State<ColorPalette> createState() => _ColorPaletteState();
}

class _ColorPaletteState extends State<ColorPalette> {
  final List<Color> colors = [
    Color(0xffFDE995),
    Color(0xffA6E1C5),
    Color(0xffA7E0F6),
    Color(0xffE1A7FB),
    Color(0xffFF9FAE),
  ];

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
            colors.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = selectedIndex == index ? null : index;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors[index],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedIndex == index
                        ? MyColors.primaryShade300
                        : MyColors.transparent,
                    width: 3,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        if (selectedIndex != null)
          SizedBox(
            width: MySizes.screenWidth(context) * .5,
            child: ColorPicker(
              portraitOnly: true,
              enableAlpha: false,
              pickerAreaHeightPercent: 0.5,
              pickerColor: colors[selectedIndex!],
              onColorChanged: (color) {
                setState(() {
                  colors[selectedIndex!] = color;
                });
              },
            ),
          ),
      ],
    );
  }
}
