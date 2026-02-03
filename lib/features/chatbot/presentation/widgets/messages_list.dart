import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../domain/entities/chat_message.dart';
import '../cubit/chatbot_state.dart';
import 'message_bubble.dart';

class MessagesList extends StatelessWidget {
  final ChatbotState state;
  final ScrollController scrollController;
  final String? userName;

  const MessagesList({
    super.key,
    required this.state,
    required this.scrollController,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    if (state is ChatbotInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    List<ChatMessage> messages = [];
    if (state is ChatbotLoaded) {
      messages = (state as ChatbotLoaded).messages;
    } else if (state is ChatbotMessageSending) {
      messages = (state as ChatbotMessageSending).messages;
    }

    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.messageCircle,
              size: ResponsiveHelper.responsiveValue(context, 64),
              color: MyColors.primaryShade300,
            ),
            SizedBox(height: MySizes.spaceMd(context)),
            Text(
              'Hi ${userName ?? 'User'}',
              style: context.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: MyColors.textPrimary,
              ),
            ),
            SizedBox(height: MySizes.spaceXs(context)),
            Text(
              'How can I help you today?',
              style: context.bodyLarge.copyWith(color: MyColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: MySizes.paddingMd(context),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return MessageBubble(message: messages[index]);
      },
    );
  }
}
