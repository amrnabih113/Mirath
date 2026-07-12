import 'package:flutter/material.dart';

import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../domain/entities/session.dart';

class SessionListTile extends StatelessWidget {
  final Session session;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const SessionListTile({
    super.key,
    required this.session,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final createdAt = session.createdAt?.toLocal();
    final subtitle = createdAt != null
        ? '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')} · ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}'
        : 'No timestamp';

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: MySizes.spaceMd(context),
          vertical: MySizes.spaceXs(context),
        ),
        title: Text(
          session.title ?? 'Untitled',
          style: context.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: MyColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: context.bodySmall.copyWith(color: MyColors.textSecondary),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: MyColors.error.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.delete_outline),
            color: MyColors.error,
            onPressed: onDelete,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
