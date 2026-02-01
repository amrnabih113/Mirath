import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/features/home/domain/usecases/save_paper_usecase.dart';
import 'package:mirath/features/home/domain/usecases/unsave_paper_usecase.dart';
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

  const AddToReadingListDialog({
    super.key,
    required this.paperId,
    this.isSaved = false,
    this.onAdded,
  });

  @override
  State<AddToReadingListDialog> createState() => _AddToReadingListDialogState();
}

class _AddToReadingListDialogState extends State<AddToReadingListDialog> {
  @override
  Widget build(BuildContext context) {
    return _DialogContent(
      paperId: widget.paperId,
      isSaved: widget.isSaved,
      onAdded: widget.onAdded,
    );
  }
}

class _DialogContent extends StatefulWidget {
  final String paperId;
  final bool isSaved;
  final VoidCallback? onAdded;

  const _DialogContent({
    required this.paperId,
    required this.isSaved,
    this.onAdded,
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
        child: SingleChildScrollView(
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
              if (_showCreateNew) ...[
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'List title',
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
                    hintText: 'Description (optional)',
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
                  title: const Text('Public list'),
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
                                    _descriptionController.text.trim().isEmpty
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
                        child: const Text('Create'),
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
                      child: const Text('Cancel'),
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
                      title: 'Success',
                      message: state.message,
                    );
                    widget.onAdded?.call();
                    Navigator.pop(context);
                  }
                  if (state is ReadingListError) {
                    MyLoaders.errorSnackBar(
                      context: context,
                      title: 'Error',
                      message: state.message,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ReadingListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ReadingListsLoaded) {
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.readingLists.length,
                          itemBuilder: (context, index) {
                            final list = state.readingLists[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const HugeIcon(
                                icon: HugeIcons.strokeRoundedBookmark02,
                              ),
                              title: Text(
                                list.title,
                                style: context.titleSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text('${list.paperCount} papers'),
                              onTap: () {
                                cubit.addPaperToList(
                                  readingListId: list.id,
                                  paperId: widget.paperId,
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(height: MySizes.spaceSm(context)),
                        if (!_showCreateNew) ...[
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (_isSaved) {
                                // Unsave paper
                                final result = await sl<UnsavePaperUseCase>()(
                                  widget.paperId,
                                );
                                result.fold(
                                  (failure) {
                                    MyLoaders.errorSnackBar(
                                      context: context,
                                      title: 'Error',
                                      message: 'Failed to unsave paper',
                                    );
                                  },
                                  (_) {
                                    setState(() => _isSaved = false);
                                    MyLoaders.successSnackBar(
                                      context: context,
                                      title: 'Success',
                                      message: 'Paper unsaved successfully',
                                    );
                                  },
                                );
                              } else {
                                // Save paper
                                final result = await sl<SavePaperUseCase>()(
                                  widget.paperId,
                                );
                                result.fold(
                                  (failure) {
                                    MyLoaders.errorSnackBar(
                                      context: context,
                                      title: 'Error',
                                      message: 'Failed to save paper',
                                    );
                                  },
                                  (_) {
                                    setState(() => _isSaved = true);
                                    MyLoaders.successSnackBar(
                                      context: context,
                                      title: 'Success',
                                      message: 'Paper saved successfully',
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
                              minimumSize: const Size(double.infinity, 48),
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
                            label: const Text('Create New List'),
                            style: OutlinedButton.styleFrom(
                              padding: MySizes.paddingSm(context),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  MySizes.borderRadiusMd(context),
                                ),
                              ),
                              foregroundColor: MyColors.primaryShade700,
                              backgroundColor: MyColors.white,
                              side: BorderSide(color: MyColors.primaryShade700),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                          ),
                        ],
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
    );
  }
}
