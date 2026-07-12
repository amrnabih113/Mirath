import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/ui/widgets/sync_indicator.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../injection/injection_container.dart';
import '../../domain/entities/session.dart';
import '../cubit/sessions_cubit.dart';
import '../cubit/sessions_state.dart';
import 'chatbot_sidebar_action_button.dart';
import 'chatbot_sidebar_session_tile.dart';

class ChatbotSidebarDrawer extends StatefulWidget {
  final String? activeSessionId;
  final bool isTemporaryChat;
  final VoidCallback onNewChat;
  final Future<void> Function() onTemporaryChat;
  final Future<void> Function(Session session) onSessionSelected;
  final String? userName;

  const ChatbotSidebarDrawer({
    super.key,
    required this.activeSessionId,
    required this.isTemporaryChat,
    required this.onNewChat,
    required this.onTemporaryChat,
    required this.onSessionSelected,
    this.userName,
  });

  @override
  State<ChatbotSidebarDrawer> createState() => _ChatbotSidebarDrawerState();
}

class _ChatbotSidebarDrawerState extends State<ChatbotSidebarDrawer> {
  late final SessionsCubit _sessionsCubit;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _sessionsCubit = sl<SessionsCubit>();
    _sessionsCubit.loadSessions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _sessionsCubit.close();
    super.dispose();
  }

  List<Session> _filterSessions(List<Session> sessions) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return sessions;
    return sessions.where((session) {
      final title = (session.title ?? 'Untitled').toLowerCase();
      final id = session.id.toLowerCase();
      return title.contains(q) || id.contains(q);
    }).toList();
  }

  String _formatTimestamp(DateTime? dateTime) {
    if (dateTime == null) return '--';
    final local = dateTime.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final suffix = local.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _sessionsCubit,
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.9,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                MyColors.white,
                MyColors.primaryShade50.withValues(alpha: 0.9),
                MyColors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    MySizes.spaceMd(context),
                    MySizes.spaceSm(context),
                    MySizes.spaceMd(context),
                    MySizes.spaceMd(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Hero(
                            tag: 'chatbot-logo',
                            child: Container(
                              width: 52,
                              height: 52,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xFFD5C6B4),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.responsiveValue(context, 12),
                                ),
                              ),
                              child: Image.asset(
                                'assets/images/logo.png',
                                height: ResponsiveHelper.responsiveValue(
                                  context,
                                  32,
                                ),
                                width: ResponsiveHelper.responsiveValue(
                                  context,
                                  32,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: ResponsiveHelper.responsiveValue(
                              context,
                              12,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Mirath AI', style: context.titleMedium),
                                SizedBox(
                                  height: ResponsiveHelper.responsiveValue(
                                    context,
                                    4,
                                  ),
                                ),
                                Text(
                                  'Premium chat workspace',
                                  style: context.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      ChatbotSidebarActionButton(
                        label: 'New Chat',
                        icon: Icons.add_rounded,
                        filled: true,
                        color: MyColors.primaryShade800,
                        onTap: () {
                          context.pop();
                          widget.onNewChat();
                        },
                      ),
                      const SizedBox(height: 10),
                      ChatbotSidebarActionButton(
                        label: 'Temporary Chat',
                        icon: Icons.visibility_off_outlined,
                        filled: false,
                        color: MyColors.primaryShade600,
                        accent: MyColors.primaryButton.withValues(alpha: 0.18),
                        onTap: () async {
                          context.pop();
                          await widget.onTemporaryChat();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MySizes.spaceMd(context),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: 'Search chats',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                              icon: const Icon(Icons.close_rounded),
                            ),
                      filled: true,
                      fillColor: MyColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: MyColors.grey.withValues(alpha: 0.35),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: MyColors.grey.withValues(alpha: 0.35),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: MyColors.primaryShade500,
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    MySizes.spaceMd(context),
                    MySizes.spaceMd(context),
                    MySizes.spaceMd(context),
                    MySizes.spaceXs(context),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent chats',
                        style: context.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: MyColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<SessionsCubit, SessionsState>(
                    builder: (context, state) {
                      if (state is SessionsLoading) {
                        return const Center(
                          child: SyncIndicator(syncing: true),
                        );
                      }
                      if (state is SessionsError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              state.message,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      final sessions = state is SessionsLoaded
                          ? _filterSessions(state.sessions)
                          : const <Session>[];

                      if (sessions.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                HugeIcon(
                                  icon: HugeIconsStrokeRounded
                                      .strokeRoundedBubbleChat,
                                  size: ResponsiveHelper.responsiveValue(
                                    context,
                                    44,
                                  ),
                                  color: MyColors.primaryShade300,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No chats yet',
                                  style: context.titleMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Start a conversation to populate this list.',
                                  textAlign: TextAlign.center,
                                  style: context.bodySmall.copyWith(
                                    color: MyColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          MySizes.spaceMd(context),
                          0,
                          MySizes.spaceMd(context),
                          MySizes.spaceMd(context),
                        ),
                        itemCount: sessions.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: MySizes.spaceSm(context)),
                        itemBuilder: (context, index) {
                          final session = sessions[index];
                          return ChatbotSidebarSessionTile(
                            session: session,
                            isActive: widget.activeSessionId == session.id,
                            timestamp: _formatTimestamp(
                              session.updatedAt ?? session.createdAt,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              widget.onSessionSelected(session);
                            },
                            onDelete: () =>
                                _sessionsCubit.removeSession(session.id),
                            onMore: () => showModalBottomSheet<void>(
                              context: context,
                              showDragHandle: true,
                              builder: (sheetContext) => SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: HugeIcon(
                                        icon: HugeIconsStrokeRounded
                                            .strokeRoundedDelete01,
                                        color: MyColors.error,
                                      ),
                                      title: const Text('Delete'),
                                      onTap: () {
                                        Navigator.of(sheetContext).pop();
                                        _sessionsCubit.removeSession(
                                          session.id,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
