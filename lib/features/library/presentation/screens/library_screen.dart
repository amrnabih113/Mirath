import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/generated/l10n.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/library/presentation/widgets/lib_tiles.dart';
import 'package:mirath/features/library/presentation/widgets/my_item.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).your_library,
          style: context.headlineLarge.copyWith(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedPlusSign,
              size: MySizes.iconMedium(context),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Padding(
                padding: MySizes.paddingMd(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MyItem(),
                    SizedBox(height: MySizes.spaceLg(context) * 1.25),
                    LibTiles(
                      title: S.of(context).projects,
                      onTap: () {
                        context.push('/projects');
                      },
                    ),
                    SizedBox(height: MySizes.spaceMd(context)),
                    LibTiles(
                      title: S.of(context).reading_lists,
                      onTap: () {
                        context.push('/reading-lists');
                      },
                    ),
                    SizedBox(height: MySizes.spaceMd(context)),
                    LibTiles(
                      title: S.of(context).reading_history,
                      onTap: () {
                        context.push('/reading-history');
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
