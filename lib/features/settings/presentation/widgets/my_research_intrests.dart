import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/features/common/widgets/tag_chip.dart';

class MyResearchIntrests extends StatefulWidget {
  const MyResearchIntrests({super.key});

  @override
  State<MyResearchIntrests> createState() => _MyResearchIntrestsState();
}

class _MyResearchIntrestsState extends State<MyResearchIntrests> {
  final List<String> _selected = [
    'AI',
    'Flutter',
    'Dart',
    'Mobile Development',
  ];
  void _toggleInterest(String name) {
    setState(() {
      _selected.contains(name) ? _selected.remove(name) : _selected.add(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My research interests',
            style: context.labelLarge.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text('Can be different from interests on the profiles'),

          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ..._selected.map(
                (e) => GestureDetector(
                  onTap: () => _toggleInterest(e),
                  child: TagChip(label: e, hasIcon: true),
                ),
              ),

              TextButton.icon(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  backgroundColor: MyColors.primaryShade200,
                  minimumSize: const Size(0, 28),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  side: const BorderSide(color: Colors.black),
                ),
                icon: const Icon(Icons.add, color: MyColors.black, size: 25),
                label: Text(
                  'Add interest',
                  style: context.labelLarge.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: MyColors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
