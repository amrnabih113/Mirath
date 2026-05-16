import 'package:flutter/material.dart';
import '../../../core/utils/my_extenstions.dart';

class CustumTextButton extends StatelessWidget {
  const CustumTextButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.color,
    required this.labelColor,
  });
  final VoidCallback onTap;
  final String label;
  final Color color;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        backgroundColor: color,
        minimumSize: const Size(0, 28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        side: const BorderSide(color: Colors.black),
      ),
      child: Text(
        label,
        style: context.bodySmall.copyWith(fontSize: 13, color: labelColor),
      ),
    );
  }
}
