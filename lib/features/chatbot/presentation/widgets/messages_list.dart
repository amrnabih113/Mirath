import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';

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
    final messages = switch (state) {
      ChatbotLoaded(:final messages) => messages,
      _ => const <ChatMessage>[],
    };

    if (messages.isEmpty) {
      return _ChatbotGreeting(userName: userName);
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

class _ChatbotGreeting extends StatelessWidget {
  final String? userName;

  const _ChatbotGreeting({this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MySizes.paddingMd(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MySizes.spaceLg(context) * 5),
          HugeIcon(
            icon: HugeIconsStrokeRounded.strokeRoundedBubbleChat,
            size: ResponsiveHelper.responsiveValue(context, 64),
            color: MyColors.primaryShade300,
          ),
          SizedBox(height: MySizes.spaceMd(context)),
          Text('Hi ${userName ?? 'User'}', style: context.bodyMedium),
          SizedBox(height: MySizes.spaceXs(context)),
          Text('How can I help you today?', style: context.titleLarge),
        ],
      ),
    );
  }
}
