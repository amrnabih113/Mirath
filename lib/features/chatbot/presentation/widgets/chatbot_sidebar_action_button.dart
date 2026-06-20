import 'package:flutter/material.dart';

import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';

class ChatbotSidebarActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final Color color;
  final Color? accent;
  final VoidCallback onTap;

  const ChatbotSidebarActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.filled,
    required this.color,
    required this.onTap,
    this.accent,
  });

  @override
  State<ChatbotSidebarActionButton> createState() =>
      _ChatbotSidebarActionButtonState();
}

class _ChatbotSidebarActionButtonState
    extends State<ChatbotSidebarActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final background = widget.filled ? widget.color : MyColors.white;
    final borderColor = widget.filled
        ? Colors.transparent
        : widget.color.withValues(alpha: 0.24);
    final contentColor = widget.filled ? MyColors.white : widget.color;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
            boxShadow: widget.filled
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: widget.accent ?? contentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon, size: 18, color: contentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: context.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: contentColor,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: contentColor.withValues(alpha: 0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
