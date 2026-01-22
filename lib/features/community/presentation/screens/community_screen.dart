import 'package:flutter/material.dart';
import '../../../../core/utils/my_sizes.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 850),
              child: Padding(
                padding: MySizes.paddingMd(context),
                child: SafeArea(child: Column(children: [
                  
                ],
              )),
              ),
            ),
          );
        },
      ),
    );
  }
}
