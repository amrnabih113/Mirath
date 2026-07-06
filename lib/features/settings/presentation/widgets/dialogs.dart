import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';

//logout dialog
void showLogoutDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String fTextBtn,
  required String sTextBtn,
  required VoidCallback ontap,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) => Center(
      child: AlertDialog(
        actionsPadding: EdgeInsets.zero,
        title: Text(title, textAlign: TextAlign.center),
        content: Text(content, textAlign: TextAlign.center),
        actions: [
          const Divider(color: MyColors.grey, thickness: 1),
          Center(
            child: TextButton(
              onPressed: ontap,
              child: Text(
                fTextBtn,
                style: context.bodyLarge.copyWith(color: MyColors.error),
              ),
            ),
          ),
          const Divider(color: MyColors.grey, thickness: 1),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(sTextBtn),
            ),
          ),
        ],
      ),
    ),
  );
}

//clear dialog
Future<void> showMyDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String fTextBtn,
  required String sTextBtn,
  required VoidCallback? onConfirm,
}) async {
  showDialog(
    context: context,
    builder: (dialogContext) => Center(
      child: AlertDialog(
        actionsPadding: EdgeInsets.zero,
        title: Text(title, textAlign: TextAlign.center),
        content: Text(content, textAlign: TextAlign.center),
        actions: [
          const Divider(color: MyColors.grey, thickness: 1),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                if (onConfirm != null) onConfirm();
              },
              child: Text(
                fTextBtn,
                style: context.bodyLarge.copyWith(color: MyColors.error),
              ),
            ),
          ),
          const Divider(color: MyColors.grey, thickness: 1),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(sTextBtn),
            ),
          ),
        ],
      ),
    ),
  );
}

// data archive dialog
void dataArchiveDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('Data Archive Requested'),
      content: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text:
                  "We are compiling your profile, reading lists, annotations, and discussions into a ZIP archive.Because this process takes time, we will send a secure download link to johndoe@gmail.com as soon as it's ready. For your security, the ",
              style: context.bodyLarge.copyWith(
                color: MyColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'download link will expire in 48 hours.',
              style: context.bodyLarge.copyWith(
                color: MyColors.error,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop(dialogContext);
          },
          style: TextButton.styleFrom(
            backgroundColor: MyColors.primaryShade800,
          ),
          child: Text(
            'Done',
            style: context.bodyLarge.copyWith(
              color: MyColors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ),
  );
}

//button dialog
void showButtonDialog(
  BuildContext context, {
  required String title,
  required List<String> tilesName,
  required void Function(int index) onselect,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          tilesName.length,
          (index) => Column(
            children: [
              ListTile(
                onTap: () {
                  onselect(index);
                },
                title: Text(tilesName[index]),
                trailing: const HugeIcon(
                  icon: HugeIcons.strokeRoundedDownload04,
                ),
              ),
              if (index != tilesName.length - 1)
                const Divider(color: MyColors.grey, thickness: 1, height: 1),
            ],
          ),
        ),
      ),
    ),
  );
}
