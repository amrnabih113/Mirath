import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/home/domain/entities/paper_entity.dart';
import 'package:mirath/features/home/presentation/cubit/home_cubit.dart';
import 'package:mirath/features/papers/presentation/widgets/abstract_section.dart';
import 'package:mirath/features/papers/presentation/widgets/expainsion_tile_widget.dart';
import 'package:mirath/features/papers/presentation/widgets/paper_info.dart';
import 'package:mirath/features/reading_lists/presentation/widgets/add_to_reading_list_dialog.dart';

class PaperScreen extends StatefulWidget {
  final PaperEntity paper;
  final VoidCallback? backonTap;

  const PaperScreen({super.key, required this.paper, this.backonTap});

  @override
  State<PaperScreen> createState() => _PaperScreenState();
}

class _PaperScreenState extends State<PaperScreen> {
  late PaperEntity _currentPaper;

  @override
  void initState() {
    super.initState();
    _currentPaper = widget.paper;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          ResponsiveHelper.responsiveValue(context, 56),
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: AppBar(
                  leading: MyBackIcon(
                    onTap: (){
                      context.go('/home');
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedMoreHorizontal,
                        size: MySizes.iconLarge(context),
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Padding(
                padding: MySizes.paddingMd(context),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PaperInfo(
                        paper: _currentPaper,
                        onSavePressed: _onSavePressed,
                      ),
                      SizedBox(height: MySizes.spaceMd(context)),
                      AbstractSection(
                        abstractText: _currentPaper.abstract,
                        onStartDiscussion: _onStartDiscussion,
                        onViewDiscussions: _onViewDiscussions,
                      ),
                      SizedBox(height: MySizes.spaceMd(context)),
                      ExpainsionTileWidget(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onSavePressed() {
    showDialog(
      context: context,
      builder: (context) => AddToReadingListDialog(
        paperId: _currentPaper.id,
        isSaved: _currentPaper.isSaved,
        onSavedStatusChanged: (isSaved) {
          setState(() {
            _currentPaper = _currentPaper.copyWith(isSaved: isSaved);
          });
          // Refetch papers from API to get updated data
          try {
            context.read<HomeCubit>().loadAllPapers();
          } catch (e) {
            // HomeCubit might not be available if navigated from other routes
          }
        },
      ),
    );
  }

  void _onStartDiscussion() {
    context.push('/add-discussion', extra: _currentPaper);
  }

  void _onViewDiscussions() {
    context.push('/paper-discussions', extra: _currentPaper);
  }
}
