import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/home/presentation/widgets/home_shimmer_loading.dart';
import 'package:mirath/features/home/presentation/widgets/paper_card.dart';
import 'package:mirath/features/library/presentation/cubit/library_cubit.dart';

class ReadingHistoryScreen extends StatefulWidget {
  const ReadingHistoryScreen({super.key});

  @override
  State<ReadingHistoryScreen> createState() => _ReadingHistoryScreenState();
}

class _ReadingHistoryScreenState extends State<ReadingHistoryScreen> {
  String selectedValue = 'Delete';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MyBackIcon(),
        title: Text(
          'Reading History',
          style: context.headlineLarge.copyWith(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Padding(
                padding: MySizes.paddingSm(context),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: MySizes.spaceXs(context),
                            bottom: MySizes.spaceXs(context) * 0.5,
                          ),
                          child: PopupMenuButton<String>(
                            initialValue: selectedValue,
                            onSelected: (value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'Delete',
                                child: Text(
                                  'Delete',
                                  style: context.bodySmall.copyWith(
                                    color: MyColors.primaryShade900,
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Delete All',
                                child: Text(
                                  'Delete All',
                                  style: context.bodySmall.copyWith(
                                    color: MyColors.primaryShade900,
                                  ),
                                ),
                              ),
                            ],
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    selectedValue,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      BlocBuilder<LibraryCubit, LibraryState>(
                        builder: (context, state) {
                          if (state is GetReadingHistoryLoading) {
                            return const PaperListShimmer();
                          } else if (state is GetReadingHistorySuccess) {
                            return Expanded(
                              child: ListView.separated(
                                padding: const EdgeInsets.all(8),

                                itemCount: state.readingHistory.length,

                                itemBuilder: (context, index) => PaperCard(
                                  readingHistory: state.readingHistory[index],
                                  onTap: () {},
                                ),
                                separatorBuilder: (context, index) => SizedBox(
                                  height: MySizes.spaceXs(context) * 0.5,
                                ),
                              ),
                            );
                          } else if (state is GetReadingHistoryFailure) {
                            return Text(state.errorMessage);
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
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
}
