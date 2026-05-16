import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../home/domain/usecases/save_paper_usecase.dart';
import '../../../home/domain/usecases/unsave_paper_usecase.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../core/helpers/my_loaders.dart';
import '../../../../injection/injection_container.dart';
import '../../domain/entities/create_reading_list_params.dart';
import '../cubit/reading_list_cubit.dart';
import '../cubit/reading_list_state.dart';

class AddToReadingListDialog extends StatefulWidget {
  final String paperId;
  final bool isSaved;
  final VoidCallback? onAdded;
  final Function(bool)? onSavedStatusChanged;

  const AddToReadingListDialog({
    super.key,
    required this.paperId,
    this.isSaved = false,
    this.onAdded,
    this.onSavedStatusChanged,
  });

  @override
  State<AddToReadingListDialog> createState() => _AddToReadingListDialogState();
}

class _AddToReadingListDialogState extends State<AddToReadingListDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReadingListCubit>()..getUserReadingLists(),
      child: _DialogContent(
        paperId: widget.paperId,
        isSaved: widget.isSaved,
        onAdded: widget.onAdded,
        onSavedStatusChanged: widget.onSavedStatusChanged,
      ),
    );
  }
}

class _DialogContent extends StatefulWidget {
  final String paperId;
  final bool isSaved;
  final VoidCallback? onAdded;
  final Function(bool)? onSavedStatusChanged;

  const _DialogContent({
    required this.paperId,
    required this.isSaved,
    this.onAdded,
    this.onSavedStatusChanged,
  });

  @override
  State<_DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<_DialogContent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _showCreateNew = false;
  bool _isPublic = true;
  late bool _isSaved;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.isSaved;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get or create the cubit - but don't provide it here to avoid GlobalKey conflicts
    final cubit = context.read<ReadingListCubit>();

    return Dialog(
      backgroundColor: MyColors.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MySizes.borderRadiusMd(context)),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
        padding: MySizes.paddingMd(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Save to Reading List',
                  style: context.titleLarge.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const HugeIcon(icon: HugeIcons.strokeRoundedCancel01),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: MySizes.spaceMd(context)),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_showCreateNew) ...[
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: S.of(context).list_title_hint,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              MySizes.borderRadiusSm(context),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: MySizes.spaceSm(context)),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: S.of(context).description_hint,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              MySizes.borderRadiusSm(context),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: MySizes.spaceSm(context)),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: Text(S.of(context).public_list_label),
                        value: _isPublic,
                        onChanged: (value) {
                          setState(() => _isPublic = value);
                        },
                      ),
                      SizedBox(height: MySizes.spaceSm(context)),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_titleController.text.trim().isNotEmpty) {
                                  cubit.createReadingList(
                                    CreateReadingListParams(
                                      title: _titleController.text.trim(),
                                      description:
                                          _descriptionController.text
                                              .trim()
                                              .isEmpty
                                          ? null
                                          : _descriptionController.text.trim(),
                                      isPublic: _isPublic,
                                    ),
                                  );
                                  setState(() => _showCreateNew = false);
                                  _titleController.clear();
                                  _descriptionController.clear();
                                  _isPublic = true;
                                }
                              },
                              child: Text(S.of(context).create_button),
                            ),
                          ),
                          SizedBox(width: MySizes.spaceSm(context)),
                          TextButton(
                            onPressed: () {
                              setState(() => _showCreateNew = false);
                              _titleController.clear();
                              _descriptionController.clear();
                              _isPublic = true;
                            },
                            child: Text(S.of(context).cancel_button),
                          ),
                        ],
                      ),
                      SizedBox(height: MySizes.spaceMd(context)),
                      const Divider(),
                    ],
                    BlocConsumer<ReadingListCubit, ReadingListState>(
                      listener: (context, state) {
                        if (state is ReadingListOperationSuccess) {
                          MyLoaders.successSnackBar(
                            context: context,
                            title: S.of(context).success,
                            message: state.message,
                          );
                          widget.onAdded?.call();
                          Navigator.pop(context);
                        }
                        if (state is ReadingListError) {
                          MyLoaders.errorSnackBar(
                            context: context,
                            title: S.of(context).error_title,
                            message: state.message,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is ReadingListLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is ReadingListsLoaded) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!_showCreateNew) ...[
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    if (_isSaved) {
                                      // Unsave paper
                                      final result =
                                          await sl<UnsavePaperUseCase>()(
                                            widget.paperId,
                                          );
                                      result.fold(
                                        (failure) {
                                          MyLoaders.errorSnackBar(
                                            context: context,
                                            title: S.of(context).error_title,
                                            message: S
                                                .of(context)
                                                .failed_to_unsave_paper,
                                          );
                                        },
                                        (_) {
                                          setState(() => _isSaved = false);
                                          widget.onSavedStatusChanged?.call(
                                            false,
                                          );
                                          MyLoaders.successSnackBar(
                                            context: context,
                                            title: S.of(context).success,
                                            message: S
                                                .of(context)
                                                .paper_unsaved_message,
                                          );
                                        },
                                      );
                                    } else {
                                      // Save paper
                                      final result =
                                          await sl<SavePaperUseCase>()(
                                            widget.paperId,
                                          );
                                      result.fold(
                                        (failure) {
                                          // Check if it's a conflict error (409)
                                          if (failure.message
                                              .toLowerCase()
                                              .contains('already saved')) {
                                            setState(() => _isSaved = true);
                                            widget.onSavedStatusChanged?.call(
                                              true,
                                            );
                                            MyLoaders.warningSnackBar(
                                              context: context,
                                              title: S.of(context).info_title,
                                              message: failure.message,
                                            );
                                          } else {
                                            MyLoaders.errorSnackBar(
                                              context: context,
                                              title: S.of(context).error_title,
                                              message: failure.message,
                                            );
                                          }
                                        },
                                        (_) {
                                          setState(() => _isSaved = true);
                                          widget.onSavedStatusChanged?.call(
                                            true,
                                          );
                                          MyLoaders.successSnackBar(
                                            context: context,
                                            title: S.of(context).success,
                                            message: S
                                                .of(context)
                                                .paper_saved_message,
                                          );
                                        },
                                      );
                                    }
                                  },
                                  icon: HugeIcon(
                                    icon: _isSaved
                                        ? HugeIcons.strokeRoundedBookmark02
                                        : HugeIcons.strokeRoundedBookmarkAdd01,
                                  ),
                                  label: Text(
                                    _isSaved ? 'Unsave Paper' : 'Save Paper',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: MySizes.paddingSm(context),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        MySizes.borderRadiusMd(context),
                                      ),
                                    ),
                                    backgroundColor: _isSaved
                                        ? MyColors.primaryShade700
                                        : MyColors.primaryShade700,
                                    foregroundColor: MyColors.white,
                                    minimumSize: const Size(
                                      double.infinity,
                                      48,
                                    ),
                                  ),
                                ),
                                SizedBox(height: MySizes.spaceSm(context)),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    setState(() => _showCreateNew = true);
                                  },
                                  icon: const HugeIcon(
                                    icon: HugeIcons.strokeRoundedAdd01,
                                  ),
                                  label: Text(
                                    S.of(context).create_new_list_button,
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: MySizes.paddingSm(context),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        MySizes.borderRadiusMd(context),
                                      ),
                                    ),
                                    foregroundColor: MyColors.primaryShade700,
                                    backgroundColor: MyColors.white,
                                    side: BorderSide(
                                      color: MyColors.primaryShade700,
                                    ),
                                    minimumSize: const Size(
                                      double.infinity,
                                      48,
                                    ),
                                  ),
                                ),
                                SizedBox(height: MySizes.spaceSm(context)),
                                const Divider(),
                                SizedBox(height: MySizes.spaceSm(context)),
                              ],
                              Flexible(
                                child: SingleChildScrollView(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: state.readingLists.length,
                                    itemBuilder: (context, index) {
                                      final list = state.readingLists[index];
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: const HugeIcon(
                                          icon:
                                              HugeIcons.strokeRoundedBookmark02,
                                        ),
                                        title: Text(
                                          list.title,
                                          style: context.titleSmall.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${list.paperCount} papers',
                                        ),
                                        onTap: () {
                                          cubit.addPaperToList(
                                            readingListId: list.id,
                                            paperId: widget.paperId,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
