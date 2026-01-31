import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';

class PaperScreen extends StatelessWidget {
  const PaperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          ResponsiveHelper.responsiveValue(context, 55),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Center(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 850),
                  child: AppBar(
                    leading: MyBackIcon(),
                    actions: [
                      IconButton(
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedDome,
                          size: 30,
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
      ),
    );
  }
}
