import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/services/user_cache_service.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../injection/injection_container.dart';
import '../cubit/chatbot_cubit.dart';
import '../cubit/chatbot_state.dart';
import '../widgets/chat_input_area.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/messages_list.dart';

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
  final List<XFile> _selectedImages = [];
  String? _userName;

  @override
  void initState() {
    super.initState();
    _chatbotCubit = sl<ChatbotCubit>();
    _chatbotCubit.initialize();
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

  Future<void> _pickAttachment(AttachmentType type) async {
    switch (type) {
      case AttachmentType.gallery:
        final List<XFile> images = await _imagePicker.pickMultiImage();
        if (images.isNotEmpty) {
          setState(() {
            _selectedImages.addAll(images);
          });
        }
        break;
      case AttachmentType.camera:
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.camera,
        );
        if (image != null) {
          setState(() {
            _selectedImages.add(image);
          });
        }
        break;
      case AttachmentType.document:
        // TODO: Implement document picker
        break;
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty && _selectedImages.isEmpty) {
      return;
    }

    // Unfocus the text field
    FocusScope.of(context).unfocus();

    final imagePaths = _selectedImages.map((e) => e.path).toList();
    _chatbotCubit.sendMessage(
      _messageController.text.trim(),
      imagePaths: imagePaths,
    );

    _messageController.clear();
    setState(() {
      _selectedImages.clear();
    });

    _scrollToBottom();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(LucideIcons.menu, color: MyColors.textPrimary),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(
              LucideIcons.messageCircleDashed,
              color: MyColors.textPrimary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const Drawer(),
      body: BlocConsumer<ChatbotCubit, ChatbotState>(
        bloc: _chatbotCubit,
        listener: (context, state) {
          if (state is ChatbotLoaded || state is ChatbotMessageSending) {
            _scrollToBottom(followTyping: true);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Messages list
              Expanded(
                child: MessagesList(
                  state: state,
                  scrollController: _scrollController,
                  userName: _userName,
                ),
              ),

              // Input area
              ChatInputArea(
                messageController: _messageController,
                selectedImages: _selectedImages,
                onPickAttachment: _pickAttachment,
                onSendMessage: _sendMessage,
                onRemoveImage: _removeImage,
                onTextChanged: () => setState(() {}),
              ),
            ],
          );
        },
      ),
    );
  }
}
