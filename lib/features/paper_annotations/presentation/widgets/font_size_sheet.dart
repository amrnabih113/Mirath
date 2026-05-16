import 'package:flutter/material.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';

class FontSizeSheet extends StatefulWidget {
  final double currentScale;
  final Function(double) onScaleChanged;

  const FontSizeSheet({
    super.key,
    required this.currentScale,
    required this.onScaleChanged,
  });

  @override
  State<FontSizeSheet> createState() => _FontSizeSheetState();
}

class _FontSizeSheetState extends State<FontSizeSheet> {
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.currentScale.clamp(0.8, 2.0);
  }

  void _updateScale(double value) {
    final clamped = value.clamp(0.8, 2.0);
    setState(() => _sliderValue = clamped);
    widget.onScaleChanged(clamped);
  }

  void _setPreset(double value) {
    _updateScale(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MySizes.paddingLg(context),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(MySizes.borderRadiusLg(context)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: ResponsiveHelper.responsiveValue(context, 40),
              height: ResponsiveHelper.responsiveValue(context, 4),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.responsiveValue(context, 2),
                ),
              ),
            ),
          ),
          SizedBox(height: MySizes.spaceMd(context)),
          Text(
            S.of(context).font_size_title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: MySizes.spaceMd(context)),
          Row(
            children: [
              Icon(
                Icons.text_fields,
                size: MySizes.iconSmall(context),
                color: Colors.grey,
              ),
              Expanded(
                child: Slider(
                  value: _sliderValue,
                  min: 0.8,
                  max: 2.0,
                  divisions: 12,
                  label: '${(_sliderValue * 100).toInt()}%',
                  onChanged: _updateScale,
                ),
              ),
              Icon(
                Icons.text_fields,
                size: MySizes.iconLarge(context),
                color: Colors.grey,
              ),
            ],
          ),
          SizedBox(height: MySizes.spaceSm(context)),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  child: InkWell(
                    onTap: () => _setPreset(0.8),
                    child: Text(
                      'Small',
                      textAlign: TextAlign.center,
                      style: context.bodySmall,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: InkWell(
                    onTap: () => _setPreset(1.0),
                    child: Text(
                      'Normal',
                      textAlign: TextAlign.center,
                      style: context.bodySmall,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: InkWell(
                    onTap: () => _setPreset(1.5),
                    child: Text(
                      'Large',
                      textAlign: TextAlign.center,
                      style: context.bodySmall,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: InkWell(
                    onTap: () => _setPreset(2.0),
                    child: Text(
                      'XLarge',
                      textAlign: TextAlign.center,
                      style: context.bodySmall,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MySizes.spaceMd(context)),
        ],
      ),
    );
  }
}
