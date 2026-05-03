import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/home/presentation/widgets/home_shimmer_loading.dart';
import 'package:mirath/features/home/presentation/widgets/paper_card.dart';
import 'package:mirath/features/library/presentation/cubit/library_cubit.dart';
import 'package:mirath/features/library/presentation/widgets/delete_button.dart';

class ReadingHistoryScreen extends StatelessWidget {
  const ReadingHistoryScreen({super.key});

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
        actions: [DeleteButton()],
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BlocBuilder<LibraryCubit, LibraryState>(
                        builder: (context, state) {
                          if (state is GetReadingHistoryLoading) {
                            return const PaperListShimmer();
                          } else if (state is GetReadingHistorySuccess) {
                            if (state.readingHistory.isEmpty) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('You haven’t read any research papers'),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Explore',
                                      style: context.bodyLarge.copyWith(
                                        decoration: TextDecoration.underline,
                                        decorationThickness: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Expanded(
                                child: ListView.separated(
                                  padding: const EdgeInsets.all(8),

                                  itemCount: state.readingHistory.length,

                                  itemBuilder: (context, index) => PaperCard(
                                    paper: state.readingHistory[index].paper,
                                    onTap: () {},
                                  ),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height: MySizes.spaceXs(context) * 0.5,
                                      ),
                                ),
                              );
                            }
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
