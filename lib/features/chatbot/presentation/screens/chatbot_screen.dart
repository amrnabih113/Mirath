import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mirath/core/utils/my_extenstions.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/network/network_manager.dart';
import '../../../../core/services/user_cache_service.dart';
import '../../../../core/ui/widgets/offline_banner.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../injection/injection_container.dart';
import '../../domain/entities/session.dart';
import '../widgets/chat_input_area.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/chatbot_sidebar_drawer.dart';
import '../widgets/messages_list.dart';
import '../cubit/chatbot_cubit.dart';
import '../cubit/chatbot_state.dart';
import '../../../../core/ui/widgets/my_app_bar.dart';
import '../../../../core/ui/widgets/my_body.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  late ChatbotCubit _chatbotCubit;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final List<File> _selectedFiles = [];
  String? _userName;
  File? _selectedAudioFile;
  int? _selectedAudioDuration;

  @override
  void initState() {
    super.initState();
    _chatbotCubit = sl<ChatbotCubit>();
    _loadUserName();

    // Scroll to bottom after initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadUserName() {
    try {
      final userData = sl<UserCacheService>().getCachedUser();
      setState(() {
        _userName = userData?.username ?? 'User';
      });
    } catch (_) {
      _userName = 'User';
    }
  }

  Future<void> _pickAttachment(InputAttachmentType type) async {
    switch (type) {
      case InputAttachmentType.gallery:
        final images = await _imagePicker.pickMultiImage();

        if (images.isNotEmpty) {
          setState(() {
            _selectedFiles.addAll(images.map((e) => File(e.path)));
          });
        }
        break;

      case InputAttachmentType.camera:
        final image = await _imagePicker.pickImage(source: ImageSource.camera);

        if (image != null) {
          setState(() {
            _selectedFiles.add(File(image.path));
          });
        }
        break;

      case InputAttachmentType.document:
        break;
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  void _sendMessage() {
    final hasText = _messageController.text.trim().isNotEmpty;
    final hasImages = _selectedFiles.isNotEmpty;
    final hasAudio = _selectedAudioFile != null;

    if (!hasText && !hasImages && !hasAudio) {
      return;
    }

    FocusScope.of(context).unfocus();

    _chatbotCubit.sendMessage(
      _messageController.text.trim(),
      imagePaths: _selectedFiles.map((e) => e.path).toList(),
      audioFile: _selectedAudioFile,
      audioDuration: _selectedAudioDuration,
    );

    _messageController.clear();

    setState(() {
      _selectedFiles.clear();
      _selectedAudioFile = null;
      _selectedAudioDuration = null;
    });

    _scrollToBottom();
  }

  Future<void> _onVoiceRecorded(File file, int duration) async {
    final maxBytes = 25 * 1024 * 1024;

    if (!file.existsSync()) return;

    if (file.lengthSync() > maxBytes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio file too large (max 25MB)')),
      );
      return;
    }

    if (duration > 120) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio too long (max 120s)')),
      );
      return;
    }

    setState(() {
      _selectedAudioFile = file;
      _selectedAudioDuration = duration;
    });

    // Wait one frame so the state is updated.
    await Future.delayed(Duration.zero);

    _sendMessage();
  }

  void _scrollToBottom({bool followTyping = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final maxExtent = _scrollController.position.maxScrollExtent;
        if (followTyping) {
          _scrollController.jumpTo(maxExtent);
          return;
        }
        _scrollController.animateTo(
          maxExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatbotCubit, ChatbotState>(
      bloc: _chatbotCubit,
      listener: (context, state) {
        if (state is ChatbotLoaded) {
          _scrollToBottom(followTyping: true);
        }
      },
      builder: (context, state) {
        final isTemporaryChat = switch (state) {
          ChatbotLoaded(:final isTemporaryChat) => isTemporaryChat,
          ChatbotMessageSending(:final isTemporaryChat) => isTemporaryChat,
          _ => false,
        };
        final currentSessionId = switch (state) {
          ChatbotLoaded(:final currentSessionId) => currentSessionId,
          ChatbotMessageSending(:final currentSessionId) => currentSessionId,
          _ => null,
        };

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _dismissKeyboard,
          child: Scaffold(
            appBar: MyAppBar(
              elevation: 0,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedMenu01,
                    color: MyColors.textPrimary,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              title: Text('Chat', style: context.titleMedium),
              actions: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: isTemporaryChat
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            key: const ValueKey('temp-badge'),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: MyColors.primaryButton.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: MyColors.primaryButton.withValues(
                                  alpha: 0.18,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.visibility_off_outlined,
                                  size: 16,
                                  color: MyColors.primaryButton,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Temporary',
                                  style: context.labelMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: MyColors.primaryButton,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(
                          key: ValueKey('temp-badge-empty'),
                        ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.responsiveValue(context, 20),
                  ),
                  child: InkWell(
                    onTap: () {
                      _chatbotCubit.isTemporaryChat
                          ? _chatbotCubit.startNewChat()
                          : _chatbotCubit.startTemporaryChat();
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: SvgPicture.asset(
                      'assets/images/bubble-chat-temporary-stroke-rounded.svg',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ],
            ),
            drawer: ChatbotSidebarDrawer(
              activeSessionId: currentSessionId,
              isTemporaryChat: isTemporaryChat,
              onNewChat: _chatbotCubit.startNewChat,
              onTemporaryChat: _chatbotCubit.startTemporaryChat,
              onSessionSelected: (Session session) async {
                FocusScope.of(context).unfocus();
                _messageController.clear();
                setState(() {
                  _selectedFiles.clear();
                });
                await _chatbotCubit.loadSession(session);
                _scrollToBottom(followTyping: true);
              },
              userName: _userName,
            ),
            body: MyBody(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  if (!NetworkManager.instance.currentConnectionStatus)
                    const OfflineBanner(),
                  Expanded(
                    child: MessagesList(
                      state: state,
                      scrollController: _scrollController,
                      userName: _userName,
                    ),
                  ),
                  ChatInputArea(
                    messageController: _messageController,
                    selectedFiles: _selectedFiles,
                    onPickAttachment: _pickAttachment,
                    onSendMessage: _sendMessage,
                    onRemoveImage: _removeImage,
                    onTextChanged: () => setState(() {}),
                    onVoiceRecorded: _onVoiceRecorded,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
