import 'package:flutter/material.dart';

class SyncIndicator extends StatelessWidget {
  final bool syncing;
  const SyncIndicator({super.key, required this.syncing});

  @override
  Widget build(BuildContext context) {
    if (!syncing) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 6,
          height: 6,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 8),
        Text('Syncing', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
